1 /*
2 
3 https://t.me/BBACONPORTAL
4 https://twitter.com/BBACON_ERC
5 
6 */
7 
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
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
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC20 {
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79 
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function decimals() external view returns (uint8);
85 }
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     mapping(address => uint256) private _balances;
89 
90     mapping(address => mapping(address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
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
262             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263             // benefit is lost if 'b' is also tested.
264             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265             if (a == 0) return (true, 0);
266             uint256 c = a * b;
267             if (c / a != b) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a / b);
276         }
277     }
278 
279     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (b == 0) return (false, 0);
282             return (true, a % b);
283         }
284     }
285 
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a + b;
288     }
289 
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a - b;
292     }
293 
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a * b;
296     }
297 
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a / b;
300     }
301 
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a % b;
304     }
305 
306     function sub(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b <= a, errorMessage);
313             return a - b;
314         }
315     }
316 
317     function div(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         unchecked {
323             require(b > 0, errorMessage);
324             return a / b;
325         }
326     }
327 
328     function mod(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b > 0, errorMessage);
335             return a % b;
336         }
337     }
338 }
339 
340 interface IUniswapV2Factory {
341     event PairCreated(
342         address indexed token0,
343         address indexed token1,
344         address pair,
345         uint256
346     );
347 
348     function feeTo() external view returns (address);
349 
350     function feeToSetter() external view returns (address);
351 
352     function getPair(address tokenA, address tokenB)
353         external
354         view
355         returns (address pair);
356 
357     function allPairs(uint256) external view returns (address pair);
358 
359     function allPairsLength() external view returns (uint256);
360 
361     function createPair(address tokenA, address tokenB)
362         external
363         returns (address pair);
364 
365     function setFeeTo(address) external;
366 
367     function setFeeToSetter(address) external;
368 }
369 
370 interface IUniswapV2Pair {
371     event Approval(
372         address indexed owner,
373         address indexed spender,
374         uint256 value
375     );
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     function name() external pure returns (string memory);
379 
380     function symbol() external pure returns (string memory);
381 
382     function decimals() external pure returns (uint8);
383 
384     function totalSupply() external view returns (uint256);
385 
386     function balanceOf(address owner) external view returns (uint256);
387 
388     function allowance(address owner, address spender)
389         external
390         view
391         returns (uint256);
392 
393     function approve(address spender, uint256 value) external returns (bool);
394 
395     function transfer(address to, uint256 value) external returns (bool);
396 
397     function transferFrom(
398         address from,
399         address to,
400         uint256 value
401     ) external returns (bool);
402 
403     function DOMAIN_SEPARATOR() external view returns (bytes32);
404 
405     function PERMIT_TYPEHASH() external pure returns (bytes32);
406 
407     function nonces(address owner) external view returns (uint256);
408 
409     function permit(
410         address owner,
411         address spender,
412         uint256 value,
413         uint256 deadline,
414         uint8 v,
415         bytes32 r,
416         bytes32 s
417     ) external;
418 
419     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
420     event Burn(
421         address indexed sender,
422         uint256 amount0,
423         uint256 amount1,
424         address indexed to
425     );
426     event Swap(
427         address indexed sender,
428         uint256 amount0In,
429         uint256 amount1In,
430         uint256 amount0Out,
431         uint256 amount1Out,
432         address indexed to
433     );
434     event Sync(uint112 reserve0, uint112 reserve1);
435 
436     function MINIMUM_LIQUIDITY() external pure returns (uint256);
437 
438     function factory() external view returns (address);
439 
440     function token0() external view returns (address);
441 
442     function token1() external view returns (address);
443 
444     function getReserves()
445         external
446         view
447         returns (
448             uint112 reserve0,
449             uint112 reserve1,
450             uint32 blockTimestampLast
451         );
452 
453     function price0CumulativeLast() external view returns (uint256);
454 
455     function price1CumulativeLast() external view returns (uint256);
456 
457     function kLast() external view returns (uint256);
458 
459     function mint(address to) external returns (uint256 liquidity);
460 
461     function burn(address to)
462         external
463         returns (uint256 amount0, uint256 amount1);
464 
465     function swap(
466         uint256 amount0Out,
467         uint256 amount1Out,
468         address to,
469         bytes calldata data
470     ) external;
471 
472     function skim(address to) external;
473 
474     function sync() external;
475 
476     function initialize(address, address) external;
477 }
478 
479 interface IUniswapV2Router02 {
480     function factory() external pure returns (address);
481 
482     function WETH() external pure returns (address);
483 
484     function addLiquidity(
485         address tokenA,
486         address tokenB,
487         uint256 amountADesired,
488         uint256 amountBDesired,
489         uint256 amountAMin,
490         uint256 amountBMin,
491         address to,
492         uint256 deadline
493     )
494         external
495         returns (
496             uint256 amountA,
497             uint256 amountB,
498             uint256 liquidity
499         );
500 
501     function addLiquidityETH(
502         address token,
503         uint256 amountTokenDesired,
504         uint256 amountTokenMin,
505         uint256 amountETHMin,
506         address to,
507         uint256 deadline
508     )
509         external
510         payable
511         returns (
512             uint256 amountToken,
513             uint256 amountETH,
514             uint256 liquidity
515         );
516 
517     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
518         uint256 amountIn,
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external;
524 
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external payable;
531 
532     function swapExactTokensForETHSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 }
540 
541 contract BBACON is ERC20, Ownable {
542     using SafeMath for uint256;
543 
544     IUniswapV2Router02 public immutable uniswapV2Router;
545     address public immutable uniswapV2Pair;
546     address public constant deadAddress = address(0xdead);
547 
548     bool private swapping;
549 
550     address public marketingWallet;
551     address public devWallet;
552 
553     uint256 public maxTransactionAmount;
554     uint256 public swapTokensAtAmount;
555     uint256 public maxWallet;
556 
557     uint256 public percentForLPBurn = 25; // 25 = .25%
558     bool public lpBurnEnabled = true;
559     uint256 public lpBurnFrequency = 3600 seconds;
560     uint256 public lastLpBurnTime;
561 
562     uint256 public manualBurnFrequency = 30 minutes;
563     uint256 public lastManualLpBurnTime;
564 
565     bool public limitsInEffect = true;
566     bool public tradingActive = false;
567     bool public swapEnabled = false;
568 
569     mapping(address => uint256) private _holderLastTransferTimestamp;
570     bool public transferDelayEnabled = true;
571 
572     uint256 public buyTotalFees;
573     uint256 public buyMarketingFee;
574     uint256 public buyLiquidityFee;
575     uint256 public buyDevFee;
576 
577     uint256 public sellTotalFees;
578     uint256 public sellMarketingFee;
579     uint256 public sellLiquidityFee;
580     uint256 public sellDevFee;
581 
582     uint256 public tokensForMarketing;
583     uint256 public tokensForLiquidity;
584     uint256 public tokensForDev;
585 
586     mapping(address => bool) private _isExcludedFromFees;
587     mapping(address => bool) public _isExcludedMaxTransactionAmount;
588 
589     mapping(address => bool) public automatedMarketMakerPairs;
590 
591     event UpdateUniswapV2Router(
592         address indexed newAddress,
593         address indexed oldAddress
594     );
595 
596     event ExcludeFromFees(address indexed account, bool isExcluded);
597 
598     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
599 
600     event marketingWalletUpdated(
601         address indexed newWallet,
602         address indexed oldWallet
603     );
604 
605     event devWalletUpdated(
606         address indexed newWallet,
607         address indexed oldWallet
608     );
609 
610     event SwapAndLiquify(
611         uint256 tokensSwapped,
612         uint256 ethReceived,
613         uint256 tokensIntoLiquidity
614     );
615 
616     event AutoNukeLP();
617 
618     event ManualNukeLP();
619 
620     constructor() ERC20("B Bacon", "BBACON") {
621         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
622             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
623         );
624 
625         excludeFromMaxTransaction(address(_uniswapV2Router), true);
626         uniswapV2Router = _uniswapV2Router;
627 
628         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
629             .createPair(address(this), _uniswapV2Router.WETH());
630         excludeFromMaxTransaction(address(uniswapV2Pair), true);
631         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
632 
633         uint256 _buyMarketingFee = 10;
634         uint256 _buyLiquidityFee = 0;
635         uint256 _buyDevFee = 0;
636 
637         uint256 _sellMarketingFee = 40;
638         uint256 _sellLiquidityFee = 0;
639         uint256 _sellDevFee = 0;
640 
641         uint256 totalSupply = 21_000_000_000 * 1e18;
642 
643         maxTransactionAmount = 210_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
644         maxWallet = 210_000_000 * 1e18; // 1% from total supply maxWallet
645         swapTokensAtAmount = (totalSupply * 10) / 1000; 
646 
647         buyMarketingFee = _buyMarketingFee;
648         buyLiquidityFee = _buyLiquidityFee;
649         buyDevFee = _buyDevFee;
650         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
651 
652         sellMarketingFee = _sellMarketingFee;
653         sellLiquidityFee = _sellLiquidityFee;
654         sellDevFee = _sellDevFee;
655         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
656 
657         marketingWallet = address(0x69Da9b208F84DaA1422cC15a251495a6127E6477); // set as marketing wallet
658         devWallet = address(0x2BBc3577dec0aA8e1bd1E8F6Dd62327c903D2077); // set as dev wallet
659 
660         excludeFromFees(owner(), true);
661         excludeFromFees(address(this), true);
662         excludeFromFees(address(0xdead), true);
663 
664         excludeFromMaxTransaction(owner(), true);
665         excludeFromMaxTransaction(address(this), true);
666         excludeFromMaxTransaction(address(0xdead), true);
667 
668         _mint(msg.sender, totalSupply);
669     }
670 
671     receive() external payable {}
672 
673     function enableTrading() external onlyOwner {
674         tradingActive = true;
675         swapEnabled = true;
676         lastLpBurnTime = block.timestamp;
677     }
678 
679     function removeLimits() external onlyOwner returns (bool) {
680         limitsInEffect = false;
681         return true;
682     }
683 
684     function disableTransferDelay() external onlyOwner returns (bool) {
685         transferDelayEnabled = false;
686         return true;
687     }
688 
689     function updateSwapTokensAtAmount(uint256 newAmount)
690         external
691         onlyOwner
692         returns (bool)
693     {
694         require(
695             newAmount >= (totalSupply() * 1) / 100000,
696             "Swap amount cannot be lower than 0.001% total supply."
697         );
698         require(
699             newAmount <= (totalSupply() * 5) / 1000,
700             "Swap amount cannot be higher than 0.5% total supply."
701         );
702         swapTokensAtAmount = newAmount;
703         return true;
704     }
705 
706     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
707         require(
708             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
709             "Cannot set maxTransactionAmount lower than 0.1%"
710         );
711         maxTransactionAmount = newNum * (10**18);
712     }
713 
714     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
715         require(
716             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
717             "Cannot set maxWallet lower than 0.5%"
718         );
719         maxWallet = newNum * (10**18);
720     }
721 
722     function excludeFromMaxTransaction(address updAds, bool isEx)
723         public
724         onlyOwner
725     {
726         _isExcludedMaxTransactionAmount[updAds] = isEx;
727     }
728 
729     function updateSwapEnabled(bool enabled) external onlyOwner {
730         swapEnabled = enabled;
731     }
732 
733     function updateBuyFees(
734         uint256 _marketingFee,
735         uint256 _liquidityFee,
736         uint256 _devFee
737     ) external onlyOwner {
738         buyMarketingFee = _marketingFee;
739         buyLiquidityFee = _liquidityFee;
740         buyDevFee = _devFee;
741         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
742         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
743     }
744 
745     function updateSellFees(
746         uint256 _marketingFee,
747         uint256 _liquidityFee,
748         uint256 _devFee
749     ) external onlyOwner {
750         sellMarketingFee = _marketingFee;
751         sellLiquidityFee = _liquidityFee;
752         sellDevFee = _devFee;
753         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
754         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
755     }
756 
757     function excludeFromFees(address account, bool excluded) public onlyOwner {
758         _isExcludedFromFees[account] = excluded;
759         emit ExcludeFromFees(account, excluded);
760     }
761 
762     function setAutomatedMarketMakerPair(address pair, bool value)
763         public
764         onlyOwner
765     {
766         require(
767             pair != uniswapV2Pair,
768             "The pair cannot be removed from automatedMarketMakerPairs"
769         );
770 
771         _setAutomatedMarketMakerPair(pair, value);
772     }
773 
774     function _setAutomatedMarketMakerPair(address pair, bool value) private {
775         automatedMarketMakerPairs[pair] = value;
776 
777         emit SetAutomatedMarketMakerPair(pair, value);
778     }
779 
780     function updateMarketingWallet(address newMarketingWallet)
781         external
782         onlyOwner
783     {
784         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
785         marketingWallet = newMarketingWallet;
786     }
787 
788     function updateDevWallet(address newWallet) external onlyOwner {
789         emit devWalletUpdated(newWallet, devWallet);
790         devWallet = newWallet;
791     }
792 
793     function isExcludedFromFees(address account) public view returns (bool) {
794         return _isExcludedFromFees[account];
795     }
796 
797     event BoughtEarly(address indexed sniper);
798 
799     function _transfer(
800         address from,
801         address to,
802         uint256 amount
803     ) internal override {
804         require(from != address(0), "ERC20: transfer from the zero address");
805         require(to != address(0), "ERC20: transfer to the zero address");
806 
807         if (amount == 0) {
808             super._transfer(from, to, 0);
809             return;
810         }
811 
812         if (limitsInEffect) {
813             if (
814                 from != owner() &&
815                 to != owner() &&
816                 to != address(0) &&
817                 to != address(0xdead) &&
818                 !swapping
819             ) {
820                 if (!tradingActive) {
821                     require(
822                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
823                         "Trading is not active."
824                     );
825                 }
826 
827                 if (transferDelayEnabled) {
828                     if (
829                         to != owner() &&
830                         to != address(uniswapV2Router) &&
831                         to != address(uniswapV2Pair)
832                     ) {
833                         require(
834                             _holderLastTransferTimestamp[tx.origin] <
835                                 block.number,
836                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
837                         );
838                         _holderLastTransferTimestamp[tx.origin] = block.number;
839                     }
840                 }
841 
842                 //when buy
843                 if (
844                     automatedMarketMakerPairs[from] &&
845                     !_isExcludedMaxTransactionAmount[to]
846                 ) {
847                     require(
848                         amount <= maxTransactionAmount,
849                         "Buy transfer amount exceeds the maxTransactionAmount."
850                     );
851                     require(
852                         amount + balanceOf(to) <= maxWallet,
853                         "Max wallet exceeded"
854                     );
855                 }
856                 //when sell
857                 else if (
858                     automatedMarketMakerPairs[to] &&
859                     !_isExcludedMaxTransactionAmount[from]
860                 ) {
861                     require(
862                         amount <= maxTransactionAmount,
863                         "Sell transfer amount exceeds the maxTransactionAmount."
864                     );
865                 } else if (!_isExcludedMaxTransactionAmount[to]) {
866                     require(
867                         amount + balanceOf(to) <= maxWallet,
868                         "Max wallet exceeded"
869                     );
870                 }
871             }
872         }
873 
874         uint256 contractTokenBalance = balanceOf(address(this));
875 
876         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
877 
878         if (
879             canSwap &&
880             swapEnabled &&
881             !swapping &&
882             !automatedMarketMakerPairs[from] &&
883             !_isExcludedFromFees[from] &&
884             !_isExcludedFromFees[to]
885         ) {
886             swapping = true;
887 
888             swapBack();
889 
890             swapping = false;
891         }
892 
893         if (
894             !swapping &&
895             automatedMarketMakerPairs[to] &&
896             lpBurnEnabled &&
897             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
898             !_isExcludedFromFees[from]
899         ) {
900             autoBurnLiquidityPairTokens();
901         }
902 
903         bool takeFee = !swapping;
904 
905         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
906             takeFee = false;
907         }
908 
909         uint256 fees = 0;
910         if (takeFee) {
911             // on sell
912             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
913                 fees = amount.mul(sellTotalFees).div(100);
914                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
915                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
916                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
917             }
918             // on buy
919             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
920                 fees = amount.mul(buyTotalFees).div(100);
921                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
922                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
923                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
924             }
925 
926             if (fees > 0) {
927                 super._transfer(from, address(this), fees);
928             }
929 
930             amount -= fees;
931         }
932 
933         super._transfer(from, to, amount);
934     }
935 
936     function swapTokensForEth(uint256 tokenAmount) private {
937         address[] memory path = new address[](2);
938         path[0] = address(this);
939         path[1] = uniswapV2Router.WETH();
940 
941         _approve(address(this), address(uniswapV2Router), tokenAmount);
942 
943         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
944             tokenAmount,
945             0, // accept any amount of ETH
946             path,
947             address(this),
948             block.timestamp
949         );
950     }
951 
952     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
953         _approve(address(this), address(uniswapV2Router), tokenAmount);
954 
955         uniswapV2Router.addLiquidityETH{value: ethAmount}(
956             address(this),
957             tokenAmount,
958             0, // slippage is unavoidable
959             0, // slippage is unavoidable
960             deadAddress,
961             block.timestamp
962         );
963     }
964 
965     function swapBack() private {
966         uint256 contractBalance = balanceOf(address(this));
967         uint256 totalTokensToSwap = tokensForLiquidity +
968             tokensForMarketing +
969             tokensForDev;
970         bool success;
971 
972         if (contractBalance == 0 || totalTokensToSwap == 0) {
973             return;
974         }
975 
976         if (contractBalance > swapTokensAtAmount * 20) {
977             contractBalance = swapTokensAtAmount * 20;
978         }
979 
980         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
981             totalTokensToSwap /
982             2;
983         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
984 
985         uint256 initialETHBalance = address(this).balance;
986 
987         swapTokensForEth(amountToSwapForETH);
988 
989         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
990 
991         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
992             totalTokensToSwap
993         );
994         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
995 
996         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
997 
998         tokensForLiquidity = 0;
999         tokensForMarketing = 0;
1000         tokensForDev = 0;
1001 
1002         (success, ) = address(devWallet).call{value: ethForDev}("");
1003 
1004         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1005             addLiquidity(liquidityTokens, ethForLiquidity);
1006             emit SwapAndLiquify(
1007                 amountToSwapForETH,
1008                 ethForLiquidity,
1009                 tokensForLiquidity
1010             );
1011         }
1012 
1013         (success, ) = address(marketingWallet).call{
1014             value: address(this).balance
1015         }("");
1016     }
1017 
1018     function setAutoLPBurnSettings(
1019         uint256 _frequencyInSeconds,
1020         uint256 _percent,
1021         bool _Enabled
1022     ) external onlyOwner {
1023         require(
1024             _frequencyInSeconds >= 600,
1025             "cannot set buyback more often than every 10 minutes"
1026         );
1027         require(
1028             _percent <= 1000 && _percent >= 0,
1029             "Must set auto LP burn percent between 0% and 10%"
1030         );
1031         lpBurnFrequency = _frequencyInSeconds;
1032         percentForLPBurn = _percent;
1033         lpBurnEnabled = _Enabled;
1034     }
1035 
1036     function autoBurnLiquidityPairTokens() internal returns (bool) {
1037         lastLpBurnTime = block.timestamp;
1038 
1039         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1040 
1041         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1042             10000
1043         );
1044 
1045         if (amountToBurn > 0) {
1046             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1047         }
1048 
1049         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1050         pair.sync();
1051         emit AutoNukeLP();
1052         return true;
1053     }
1054 
1055     function manualBurnLiquidityPairTokens(uint256 percent)
1056         external
1057         onlyOwner
1058         returns (bool)
1059     {
1060         require(
1061             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1062             "Must wait for cooldown to finish"
1063         );
1064         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1065         lastManualLpBurnTime = block.timestamp;
1066 
1067         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1068 
1069         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1070 
1071         if (amountToBurn > 0) {
1072             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1073         }
1074 
1075         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1076         pair.sync();
1077         emit ManualNukeLP();
1078         return true;
1079     }
1080 }