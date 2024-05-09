1 /**
2 
3 Website: https://thisisnotalpha.com/
4 TG:      https://t.me/ThisIsnotalpha
5 Twitter: https://twitter.com/ThisIsNotAlpha_
6 
7 ThisIsNotAlpha... Or is it?
8 
9 **/
10 // SPDX-License-Identifier: MIT
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     function renounceOwnership() public virtual onlyOwner {
43         _transferOwnership(address(0));
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         _transferOwnership(newOwner);
49     }
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IERC20Metadata is IERC20 {
82 
83     function name() external view returns (string memory);
84 
85     function symbol() external view returns (string memory);
86 
87     function decimals() external view returns (uint8);
88 }
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
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
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         uint256 accountBalance = _balances[account];
210         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
211         unchecked {
212             _balances[account] = accountBalance - amount;
213         }
214         _totalSupply -= amount;
215 
216         emit Transfer(account, address(0), amount);
217 
218         _afterTokenTransfer(account, address(0), amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _beforeTokenTransfer(
234         address from,
235         address to,
236         uint256 amount
237     ) internal virtual {}
238 
239     function _afterTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 }
245 
246 library SafeMath {
247 
248     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             uint256 c = a + b;
251             if (c < a) return (false, 0);
252             return (true, c);
253         }
254     }
255 
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
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
541 contract ThisIsNotAlpha is ERC20, Ownable {
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
552     address public liqWallet;
553 
554     uint256 public maxTransactionAmount;
555     uint256 public swapTokensAtAmount;
556     uint256 public maxWallet;
557 
558     bool public limitsInEffect = true;
559     bool public tradingActive = false;
560     bool public swapEnabled = false;
561 
562     // Anti-bot and anti-whale mappings and variables
563     mapping(address => uint256) private _holderLastTransferTimestamp;
564     bool public transferDelayEnabled = true;
565 
566     uint256 public buyTotalFees;
567     uint256 public buyMarketingFee;
568     uint256 public buyLiquidityFee;
569     uint256 public buyDevFee;
570 
571     uint256 public sellTotalFees;
572     uint256 public sellMarketingFee;
573     uint256 public sellLiquidityFee;
574     uint256 public sellDevFee;
575 
576     uint256 public tokensForMarketing;
577     uint256 public tokensForLiquidity;
578     uint256 public tokensForDev;
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
599     event devWalletUpdated(
600         address indexed newWallet,
601         address indexed oldWallet
602     );
603 
604     event liqWalletUpdated(
605         address indexed newWallet,
606         address indexed oldWallet
607     );
608 
609     event SwapAndLiquify(
610         uint256 tokensSwapped,
611         uint256 ethReceived,
612         uint256 tokensIntoLiquidity
613     );
614 
615     constructor() ERC20("This Is Not Alpha", "TINA") {
616         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
617             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
618         );
619 
620         excludeFromMaxTransaction(address(_uniswapV2Router), true);
621         uniswapV2Router = _uniswapV2Router;
622 
623         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
624             .createPair(address(this), _uniswapV2Router.WETH());
625         excludeFromMaxTransaction(address(uniswapV2Pair), true);
626         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
627 
628         uint256 _buyMarketingFee = 4;
629         uint256 _buyLiquidityFee = 2;
630         uint256 _buyDevFee = 4;
631 
632         uint256 _sellMarketingFee = 5;
633         uint256 _sellLiquidityFee = 5;
634         uint256 _sellDevFee = 5;
635 
636         uint256 totalSupply = 1_000_000 * 1e18;
637 
638         maxTransactionAmount = 20_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
639         maxWallet = 20_000 * 1e18; // 2% from total supply maxWallet
640         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
641 
642         buyMarketingFee = _buyMarketingFee;
643         buyLiquidityFee = _buyLiquidityFee;
644         buyDevFee = _buyDevFee;
645         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
646 
647         sellMarketingFee = _sellMarketingFee;
648         sellLiquidityFee = _sellLiquidityFee;
649         sellDevFee = _sellDevFee;
650         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
651 
652         marketingWallet = address(0x7C3d51E113cB99de38c2029a80Ad019013c1a957);
653         devWallet = address(0xaF8C37289CA7d42B1637cd71EBE125Cfec5f71fF);
654         liqWallet = address(0xaF8C37289CA7d42B1637cd71EBE125Cfec5f71fF);
655 
656         // exclude from paying fees or having max transaction amount
657         excludeFromFees(owner(), true);
658         excludeFromFees(address(this), true);
659         excludeFromFees(address(0xdead), true);
660 
661         excludeFromMaxTransaction(owner(), true);
662         excludeFromMaxTransaction(address(this), true);
663         excludeFromMaxTransaction(address(0xdead), true);
664 
665         _mint(msg.sender, totalSupply);
666     }
667 
668     receive() external payable {}
669 
670     function enableTrading() external onlyOwner {
671         tradingActive = true;
672         swapEnabled = true;
673     }
674 
675     // remove limits after token is stable
676     function removeLimits() external onlyOwner returns (bool) {
677         limitsInEffect = false;
678         return true;
679     }
680 
681     // disable Transfer delay - cannot be reenabled
682     function disableTransferDelay() external onlyOwner returns (bool) {
683         transferDelayEnabled = false;
684         return true;
685     }
686 
687     // change the minimum amount of tokens to sell from fees
688     function updateSwapTokensAtAmount(uint256 newAmount)
689         external
690         onlyOwner
691         returns (bool)
692     {
693         require(
694             newAmount >= (totalSupply() * 1) / 100000,
695             "Swap amount cannot be lower than 0.001% total supply."
696         );
697         require(
698             newAmount <= (totalSupply() * 5) / 1000,
699             "Swap amount cannot be higher than 0.5% total supply."
700         );
701         swapTokensAtAmount = newAmount;
702         return true;
703     }
704 
705     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
706         require(
707             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
708             "Cannot set maxTransactionAmount lower than 0.1%"
709         );
710         maxTransactionAmount = newNum * (10**18);
711     }
712 
713     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
714         require(
715             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
716             "Cannot set maxWallet lower than 0.5%"
717         );
718         maxWallet = newNum * (10**18);
719     }
720 
721     function excludeFromMaxTransaction(address updAds, bool isEx)
722         public
723         onlyOwner
724     {
725         _isExcludedMaxTransactionAmount[updAds] = isEx;
726     }
727 
728     // only use to disable contract sales if absolutely necessary (emergency use only)
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
742         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
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
754         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
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
780     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
781         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
782         marketingWallet = newMarketingWallet;
783     }
784 
785     function updateDevWallet(address newWallet) external onlyOwner {
786         emit devWalletUpdated(newWallet, devWallet);
787         devWallet = newWallet;
788     }
789 
790     function updateLiqWallet(address newLiqWallet) external onlyOwner {
791         emit liqWalletUpdated(newLiqWallet, liqWallet);
792         liqWallet = newLiqWallet;
793     }
794 
795     function isExcludedFromFees(address account) public view returns (bool) {
796         return _isExcludedFromFees[account];
797     }
798 
799     event BoughtEarly(address indexed sniper);
800 
801     function _transfer(
802         address from,
803         address to,
804         uint256 amount
805     ) internal override {
806         require(from != address(0), "ERC20: transfer from the zero address");
807         require(to != address(0), "ERC20: transfer to the zero address");
808 
809         if (amount == 0) {
810             super._transfer(from, to, 0);
811             return;
812         }
813 
814         if (limitsInEffect) {
815             if (
816                 from != owner() &&
817                 to != owner() &&
818                 to != address(0) &&
819                 to != address(0xdead) &&
820                 !swapping
821             ) {
822                 if (!tradingActive) {
823                     require(
824                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
825                         "Trading is not active."
826                     );
827                 }
828 
829                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
830                 if (transferDelayEnabled) {
831                     if (
832                         to != owner() &&
833                         to != address(uniswapV2Router) &&
834                         to != address(uniswapV2Pair)
835                     ) {
836                         require(
837                             _holderLastTransferTimestamp[tx.origin] <
838                                 block.number,
839                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
840                         );
841                         _holderLastTransferTimestamp[tx.origin] = block.number;
842                     }
843                 }
844 
845                 //when buy
846                 if (
847                     automatedMarketMakerPairs[from] &&
848                     !_isExcludedMaxTransactionAmount[to]
849                 ) {
850                     require(
851                         amount <= maxTransactionAmount,
852                         "Buy transfer amount exceeds the maxTransactionAmount."
853                     );
854                     require(
855                         amount + balanceOf(to) <= maxWallet,
856                         "Max wallet exceeded"
857                     );
858                 }
859                 //when sell
860                 else if (
861                     automatedMarketMakerPairs[to] &&
862                     !_isExcludedMaxTransactionAmount[from]
863                 ) {
864                     require(
865                         amount <= maxTransactionAmount,
866                         "Sell transfer amount exceeds the maxTransactionAmount."
867                     );
868                 } else if (!_isExcludedMaxTransactionAmount[to]) {
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max wallet exceeded"
872                     );
873                 }
874             }
875         }
876 
877         uint256 contractTokenBalance = balanceOf(address(this));
878 
879         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
880 
881         if (
882             canSwap &&
883             swapEnabled &&
884             !swapping &&
885             !automatedMarketMakerPairs[from] &&
886             !_isExcludedFromFees[from] &&
887             !_isExcludedFromFees[to]
888         ) {
889             swapping = true;
890 
891             swapBack();
892 
893             swapping = false;
894         }
895 
896         bool takeFee = !swapping;
897 
898         // if any account belongs to _isExcludedFromFee account then remove the fee
899         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
900             takeFee = false;
901         }
902 
903         uint256 fees = 0;
904         // only take fees on buys/sells, do not take on wallet transfers
905         if (takeFee) {
906             // on sell
907             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
908                 fees = amount.mul(sellTotalFees).div(100);
909                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
910                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
911                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
912             }
913             // on buy
914             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
915                 fees = amount.mul(buyTotalFees).div(100);
916                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
917                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
918                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
919             }
920 
921             if (fees > 0) {
922                 super._transfer(from, address(this), fees);
923             }
924 
925             amount -= fees;
926         }
927 
928         super._transfer(from, to, amount);
929     }
930 
931     function swapTokensForEth(uint256 tokenAmount) private {
932         // generate the uniswap pair path of token -> weth
933         address[] memory path = new address[](2);
934         path[0] = address(this);
935         path[1] = uniswapV2Router.WETH();
936 
937         _approve(address(this), address(uniswapV2Router), tokenAmount);
938 
939         // make the swap
940         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
941             tokenAmount,
942             0, // accept any amount of ETH
943             path,
944             address(this),
945             block.timestamp
946         );
947     }
948 
949     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
950         // approve token transfer to cover all possible scenarios
951         _approve(address(this), address(uniswapV2Router), tokenAmount);
952 
953         // add the liquidity
954         uniswapV2Router.addLiquidityETH{value: ethAmount}(
955             address(this),
956             tokenAmount,
957             0, // slippage is unavoidable
958             0, // slippage is unavoidable
959             liqWallet,
960             block.timestamp
961         );
962     }
963 
964     function swapBack() private {
965         uint256 contractBalance = balanceOf(address(this));
966         uint256 totalTokensToSwap = tokensForLiquidity +
967             tokensForMarketing +
968             tokensForDev;
969         bool success;
970 
971         if (contractBalance == 0 || totalTokensToSwap == 0) {
972             return;
973         }
974 
975         if (contractBalance > swapTokensAtAmount * 20) {
976             contractBalance = swapTokensAtAmount * 20;
977         }
978 
979         // Halve the amount of liquidity tokens
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
1017 }