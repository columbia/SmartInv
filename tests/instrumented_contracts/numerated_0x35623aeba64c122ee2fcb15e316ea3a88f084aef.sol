1 //
2 //  ██████╗██╗      ██████╗ ███╗   ██╗███████╗ █████╗ ██╗
3 // ██╔════╝██║     ██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║
4 // ██║     ██║     ██║   ██║██╔██╗ ██║█████╗  ███████║██║
5 // ██║     ██║     ██║   ██║██║╚██╗██║██╔══╝  ██╔══██║██║
6 // ╚██████╗███████╗╚██████╔╝██║ ╚████║███████╗██║  ██║██║
7 //  ╚═════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝
8 //  Telegram: https://t.me/cloneai
9 //
10 
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
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _transferOwnership(newOwner);
50     }
51 
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
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74 
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92 
93     function name() external view returns (string memory);
94 
95     function symbol() external view returns (string memory);
96 
97     function decimals() external view returns (uint8);
98 }
99 
100 
101 contract ERC20 is Context, IERC20, IERC20Metadata {
102     mapping(address => uint256) private _balances;
103 
104     mapping(address => mapping(address => uint256)) private _allowances;
105 
106     uint256 private _totalSupply;
107 
108     string private _name;
109     string private _symbol;
110 
111 
112     constructor(string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115     }
116 
117 
118     function name() public view virtual override returns (string memory) {
119         return _name;
120     }
121 
122 
123     function symbol() public view virtual override returns (string memory) {
124         return _symbol;
125     }
126 
127 
128     function decimals() public view virtual override returns (uint8) {
129         return 18;
130     }
131 
132 
133     function totalSupply() public view virtual override returns (uint256) {
134         return _totalSupply;
135     }
136 
137     function balanceOf(address account) public view virtual override returns (uint256) {
138         return _balances[account];
139     }
140 
141     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142         _transfer(_msgSender(), recipient, amount);
143         return true;
144     }
145 
146 
147     function allowance(address owner, address spender) public view virtual override returns (uint256) {
148         return _allowances[owner][spender];
149     }
150 
151     function approve(address spender, uint256 amount) public virtual override returns (bool) {
152         _approve(_msgSender(), spender, amount);
153         return true;
154     }
155 
156     function transferFrom(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) public virtual override returns (bool) {
161         _transfer(sender, recipient, amount);
162 
163         uint256 currentAllowance = _allowances[sender][_msgSender()];
164         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
165         unchecked {
166             _approve(sender, _msgSender(), currentAllowance - amount);
167         }
168 
169         return true;
170     }
171 
172     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
173         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
174         return true;
175     }
176 
177     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
178         uint256 currentAllowance = _allowances[_msgSender()][spender];
179         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
180         unchecked {
181             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
182         }
183 
184         return true;
185     }
186 
187     function _transfer(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) internal virtual {
192         require(sender != address(0), "ERC20: transfer from the zero address");
193         require(recipient != address(0), "ERC20: transfer to the zero address");
194 
195         _beforeTokenTransfer(sender, recipient, amount);
196 
197         uint256 senderBalance = _balances[sender];
198         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
199         unchecked {
200             _balances[sender] = senderBalance - amount;
201         }
202         _balances[recipient] += amount;
203 
204         emit Transfer(sender, recipient, amount);
205 
206         _afterTokenTransfer(sender, recipient, amount);
207     }
208 
209     function _mint(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: mint to the zero address");
211 
212         _beforeTokenTransfer(address(0), account, amount);
213 
214         _totalSupply += amount;
215         _balances[account] += amount;
216         emit Transfer(address(0), account, amount);
217 
218         _afterTokenTransfer(address(0), account, amount);
219     }
220 
221     function _burn(address account, uint256 amount) internal virtual {
222         require(account != address(0), "ERC20: burn from the zero address");
223 
224         _beforeTokenTransfer(account, address(0), amount);
225 
226         uint256 accountBalance = _balances[account];
227         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
228         unchecked {
229             _balances[account] = accountBalance - amount;
230         }
231         _totalSupply -= amount;
232 
233         emit Transfer(account, address(0), amount);
234 
235         _afterTokenTransfer(account, address(0), amount);
236     }
237 
238     function _approve(
239         address owner,
240         address spender,
241         uint256 amount
242     ) internal virtual {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245 
246         _allowances[owner][spender] = amount;
247         emit Approval(owner, spender, amount);
248     }
249 
250     function _beforeTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 
256     function _afterTokenTransfer(
257         address from,
258         address to,
259         uint256 amount
260     ) internal virtual {}
261 }
262 
263 
264 library SafeMath {
265 
266     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             uint256 c = a + b;
269             if (c < a) return (false, 0);
270             return (true, c);
271         }
272     }
273 
274     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b > a) return (false, 0);
277             return (true, a - b);
278         }
279     }
280 
281 
282     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         unchecked {
284             if (a == 0) return (true, 0);
285             uint256 c = a * b;
286             if (c / a != b) return (false, 0);
287             return (true, c);
288         }
289     }
290 
291     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a / b);
295         }
296     }
297 
298     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
299         unchecked {
300             if (b == 0) return (false, 0);
301             return (true, a % b);
302         }
303     }
304 
305 
306     function add(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a + b;
308     }
309 
310     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a - b;
312     }
313 
314     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a * b;
316     }
317 
318     function div(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a / b;
320     }
321 
322     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
323         return a % b;
324     }
325 
326     function sub(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         unchecked {
332             require(b <= a, errorMessage);
333             return a - b;
334         }
335     }
336 
337     function div(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         unchecked {
343             require(b > 0, errorMessage);
344             return a / b;
345         }
346     }
347 
348 
349     function mod(
350         uint256 a,
351         uint256 b,
352         string memory errorMessage
353     ) internal pure returns (uint256) {
354         unchecked {
355             require(b > 0, errorMessage);
356             return a % b;
357         }
358     }
359 }
360 
361 
362 interface IUniswapV2Factory {
363     event PairCreated(
364         address indexed token0,
365         address indexed token1,
366         address pair,
367         uint256
368     );
369 
370     function feeTo() external view returns (address);
371 
372     function feeToSetter() external view returns (address);
373 
374     function getPair(address tokenA, address tokenB)
375         external
376         view
377         returns (address pair);
378 
379     function allPairs(uint256) external view returns (address pair);
380 
381     function allPairsLength() external view returns (uint256);
382 
383     function createPair(address tokenA, address tokenB)
384         external
385         returns (address pair);
386 
387     function setFeeTo(address) external;
388 
389     function setFeeToSetter(address) external;
390 }
391 
392 
393 interface IUniswapV2Pair {
394     event Approval(
395         address indexed owner,
396         address indexed spender,
397         uint256 value
398     );
399     event Transfer(address indexed from, address indexed to, uint256 value);
400 
401     function name() external pure returns (string memory);
402 
403     function symbol() external pure returns (string memory);
404 
405     function decimals() external pure returns (uint8);
406 
407     function totalSupply() external view returns (uint256);
408 
409     function balanceOf(address owner) external view returns (uint256);
410 
411     function allowance(address owner, address spender)
412         external
413         view
414         returns (uint256);
415 
416     function approve(address spender, uint256 value) external returns (bool);
417 
418     function transfer(address to, uint256 value) external returns (bool);
419 
420     function transferFrom(
421         address from,
422         address to,
423         uint256 value
424     ) external returns (bool);
425 
426     function DOMAIN_SEPARATOR() external view returns (bytes32);
427 
428     function PERMIT_TYPEHASH() external pure returns (bytes32);
429 
430     function nonces(address owner) external view returns (uint256);
431 
432     function permit(
433         address owner,
434         address spender,
435         uint256 value,
436         uint256 deadline,
437         uint8 v,
438         bytes32 r,
439         bytes32 s
440     ) external;
441 
442     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
443     event Burn(
444         address indexed sender,
445         uint256 amount0,
446         uint256 amount1,
447         address indexed to
448     );
449     event Swap(
450         address indexed sender,
451         uint256 amount0In,
452         uint256 amount1In,
453         uint256 amount0Out,
454         uint256 amount1Out,
455         address indexed to
456     );
457     event Sync(uint112 reserve0, uint112 reserve1);
458 
459     function MINIMUM_LIQUIDITY() external pure returns (uint256);
460 
461     function factory() external view returns (address);
462 
463     function token0() external view returns (address);
464 
465     function token1() external view returns (address);
466 
467     function getReserves()
468         external
469         view
470         returns (
471             uint112 reserve0,
472             uint112 reserve1,
473             uint32 blockTimestampLast
474         );
475 
476     function price0CumulativeLast() external view returns (uint256);
477 
478     function price1CumulativeLast() external view returns (uint256);
479 
480     function kLast() external view returns (uint256);
481 
482     function mint(address to) external returns (uint256 liquidity);
483 
484     function burn(address to)
485         external
486         returns (uint256 amount0, uint256 amount1);
487 
488     function swap(
489         uint256 amount0Out,
490         uint256 amount1Out,
491         address to,
492         bytes calldata data
493     ) external;
494 
495     function skim(address to) external;
496 
497     function sync() external;
498 
499     function initialize(address, address) external;
500 }
501 
502 
503 interface IUniswapV2Router02 {
504     function factory() external pure returns (address);
505 
506     function WETH() external pure returns (address);
507 
508     function addLiquidity(
509         address tokenA,
510         address tokenB,
511         uint256 amountADesired,
512         uint256 amountBDesired,
513         uint256 amountAMin,
514         uint256 amountBMin,
515         address to,
516         uint256 deadline
517     )
518         external
519         returns (
520             uint256 amountA,
521             uint256 amountB,
522             uint256 liquidity
523         );
524 
525     function addLiquidityETH(
526         address token,
527         uint256 amountTokenDesired,
528         uint256 amountTokenMin,
529         uint256 amountETHMin,
530         address to,
531         uint256 deadline
532     )
533         external
534         payable
535         returns (
536             uint256 amountToken,
537             uint256 amountETH,
538             uint256 liquidity
539         );
540 
541     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
542         uint256 amountIn,
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external;
548 
549     function swapExactETHForTokensSupportingFeeOnTransferTokens(
550         uint256 amountOutMin,
551         address[] calldata path,
552         address to,
553         uint256 deadline
554     ) external payable;
555 
556     function swapExactTokensForETHSupportingFeeOnTransferTokens(
557         uint256 amountIn,
558         uint256 amountOutMin,
559         address[] calldata path,
560         address to,
561         uint256 deadline
562     ) external;
563 }
564 
565 
566 contract CloneAI is ERC20, Ownable {
567     using SafeMath for uint256;
568 
569     IUniswapV2Router02 public immutable uniswapV2Router;
570     address public immutable uniswapV2Pair;
571     address public constant deadAddress = address(0xdead);
572 
573     bool private swapping;
574 
575     address public marketingWallet;
576     address public devWallet;
577 
578     uint256 public maxTransactionAmount;
579     uint256 public swapTokensAtAmount;
580     uint256 public maxWallet;
581 
582     uint256 public percentForLPBurn = 0; 
583     bool public lpBurnEnabled = false;
584     uint256 public lpBurnFrequency = 3600 seconds;
585     uint256 public lastLpBurnTime;
586 
587     uint256 public manualBurnFrequency = 30 minutes;
588     uint256 public lastManualLpBurnTime;
589 
590     bool public limitsInEffect = true;
591     bool public tradingActive = false;
592     bool public swapEnabled = true;
593 
594     mapping(address => uint256) private _holderLastTransferTimestamp; 
595     bool public transferDelayEnabled = true;
596 
597     uint256 public buyTotalFees;
598     uint256 public buyMarketingFee;
599     uint256 public buyLiquidityFee;
600     uint256 public buyDevFee;
601 
602     uint256 public sellTotalFees;
603     uint256 public sellMarketingFee;
604     uint256 public sellLiquidityFee;
605     uint256 public sellDevFee;
606 
607     uint256 public tokensForMarketing;
608     uint256 public tokensForLiquidity;
609     uint256 public tokensForDev;
610 
611     mapping(address => bool) private _isExcludedFromFees;
612     mapping(address => bool) public _isExcludedMaxTransactionAmount;
613 
614     mapping(address => bool) public automatedMarketMakerPairs;
615 
616     event UpdateUniswapV2Router(
617         address indexed newAddress,
618         address indexed oldAddress
619     );
620 
621     event ExcludeFromFees(address indexed account, bool isExcluded);
622 
623     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
624 
625     event marketingWalletUpdated(
626         address indexed newWallet,
627         address indexed oldWallet
628     );
629 
630     event devWalletUpdated(
631         address indexed newWallet,
632         address indexed oldWallet
633     );
634 
635     event SwapAndLiquify(
636         uint256 tokensSwapped,
637         uint256 ethReceived,
638         uint256 tokensIntoLiquidity
639     );
640 
641     event AutoNukeLP();
642 
643     event ManualNukeLP();
644 
645     constructor() ERC20("Clone AI", "CAI") {
646         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
647             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
648         );
649 
650         excludeFromMaxTransaction(address(_uniswapV2Router), true);
651         uniswapV2Router = _uniswapV2Router;
652 
653         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
654             .createPair(address(this), _uniswapV2Router.WETH());
655         excludeFromMaxTransaction(address(uniswapV2Pair), true);
656         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
657 
658         uint256 _buyMarketingFee = 20;
659         uint256 _buyLiquidityFee = 0;
660         uint256 _buyDevFee = 5;
661 
662         uint256 _sellMarketingFee = 20;
663         uint256 _sellLiquidityFee = 0;
664         uint256 _sellDevFee = 5;
665 
666         uint256 totalSupply = 1_000_000_000 * 1e18;
667 
668         maxTransactionAmount = 15_000_000 * 1e18; 
669         maxWallet = 20_000_000 * 1e18; 
670         swapTokensAtAmount = (totalSupply * 5) / 10000;
671 
672         buyMarketingFee = _buyMarketingFee;
673         buyLiquidityFee = _buyLiquidityFee;
674         buyDevFee = _buyDevFee;
675         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
676 
677         sellMarketingFee = _sellMarketingFee;
678         sellLiquidityFee = _sellLiquidityFee;
679         sellDevFee = _sellDevFee;
680         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
681 
682         marketingWallet = address(0x37ABe347E71A88EbEF6086654898BcB43FF26310); 
683         devWallet = address(0x6f1CbF9Ec018c8A67fC0ea3fb77af94B432f9E3d); 
684 
685         // exclude from paying fees or having max transaction amount
686         excludeFromFees(owner(), true);
687         excludeFromFees(address(this), true);
688         excludeFromFees(address(0xdead), true);
689 
690         excludeFromMaxTransaction(owner(), true);
691         excludeFromMaxTransaction(address(this), true);
692         excludeFromMaxTransaction(address(0xdead), true);
693 
694         _mint(msg.sender, totalSupply);
695     }
696 
697     receive() external payable {}
698 
699     function enableTrading() external onlyOwner {
700         tradingActive = true;
701         swapEnabled = true;
702         lastLpBurnTime = block.timestamp;
703     }
704 
705     function removeLimits() external onlyOwner returns (bool) {
706         limitsInEffect = false;
707         return true;
708     }
709 
710     function disableTransferDelay() external onlyOwner returns (bool) {
711         transferDelayEnabled = false;
712         return true;
713     }
714 
715     function updateSwapTokensAtAmount(uint256 newAmount)
716         external
717         onlyOwner
718         returns (bool)
719     {
720         require(
721             newAmount >= (totalSupply() * 1) / 100000,
722             "Swap amount cannot be lower than 0.001% total supply."
723         );
724         require(
725             newAmount <= (totalSupply() * 5) / 1000,
726             "Swap amount cannot be higher than 0.5% total supply."
727         );
728         swapTokensAtAmount = newAmount;
729         return true;
730     }
731 
732     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
733         require(
734             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
735             "Cannot set maxTransactionAmount lower than 0.1%"
736         );
737         maxTransactionAmount = newNum * (10**18);
738     }
739 
740     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
741         require(
742             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
743             "Cannot set maxWallet lower than 0.5%"
744         );
745         maxWallet = newNum * (10**18);
746     }
747 
748     function excludeFromMaxTransaction(address updAds, bool isEx)
749         public
750         onlyOwner
751     {
752         _isExcludedMaxTransactionAmount[updAds] = isEx;
753     }
754 
755     function updateSwapEnabled(bool enabled) external onlyOwner {
756         swapEnabled = enabled;
757     }
758 
759     function updateBuyFees(
760         uint256 _marketingFee,
761         uint256 _liquidityFee,
762         uint256 _devFee
763     ) external onlyOwner {
764         buyMarketingFee = _marketingFee;
765         buyLiquidityFee = _liquidityFee;
766         buyDevFee = _devFee;
767         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
768         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
769     }
770 
771     function updateSellFees(
772         uint256 _marketingFee,
773         uint256 _liquidityFee,
774         uint256 _devFee
775     ) external onlyOwner {
776         sellMarketingFee = _marketingFee;
777         sellLiquidityFee = _liquidityFee;
778         sellDevFee = _devFee;
779         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
780         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
781     }
782 
783     function excludeFromFees(address account, bool excluded) public onlyOwner {
784         _isExcludedFromFees[account] = excluded;
785         emit ExcludeFromFees(account, excluded);
786     }
787 
788     function setAutomatedMarketMakerPair(address pair, bool value)
789         public
790         onlyOwner
791     {
792         require(
793             pair != uniswapV2Pair,
794             "The pair cannot be removed from automatedMarketMakerPairs"
795         );
796 
797         _setAutomatedMarketMakerPair(pair, value);
798     }
799 
800     function _setAutomatedMarketMakerPair(address pair, bool value) private {
801         automatedMarketMakerPairs[pair] = value;
802 
803         emit SetAutomatedMarketMakerPair(pair, value);
804     }
805 
806     function updateMarketingWallet(address newMarketingWallet)
807         external
808         onlyOwner
809     {
810         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
811         marketingWallet = newMarketingWallet;
812     }
813 
814     function updateDevWallet(address newWallet) external onlyOwner {
815         emit devWalletUpdated(newWallet, devWallet);
816         devWallet = newWallet;
817     }
818 
819     function isExcludedFromFees(address account) public view returns (bool) {
820         return _isExcludedFromFees[account];
821     }
822 
823     event BoughtEarly(address indexed sniper);
824 
825     function _transfer(
826         address from,
827         address to,
828         uint256 amount
829     ) internal override {
830         require(from != address(0), "ERC20: transfer from the zero address");
831         require(to != address(0), "ERC20: transfer to the zero address");
832 
833         if (amount == 0) {
834             super._transfer(from, to, 0);
835             return;
836         }
837 
838         if (limitsInEffect) {
839             if (
840                 from != owner() &&
841                 to != owner() &&
842                 to != address(0) &&
843                 to != address(0xdead) &&
844                 !swapping
845             ) {
846                 if (!tradingActive) {
847                     require(
848                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
849                         "Trading is not active."
850                     );
851                 }
852 
853                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
854                 if (transferDelayEnabled) {
855                     if (
856                         to != owner() &&
857                         to != address(uniswapV2Router) &&
858                         to != address(uniswapV2Pair)
859                     ) {
860                         require(
861                             _holderLastTransferTimestamp[tx.origin] <
862                                 block.number,
863                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
864                         );
865                         _holderLastTransferTimestamp[tx.origin] = block.number;
866                     }
867                 }
868 
869                 //when buy
870                 if (
871                     automatedMarketMakerPairs[from] &&
872                     !_isExcludedMaxTransactionAmount[to]
873                 ) {
874                     require(
875                         amount <= maxTransactionAmount,
876                         "Buy transfer amount exceeds the maxTransactionAmount."
877                     );
878                     require(
879                         amount + balanceOf(to) <= maxWallet,
880                         "Max wallet exceeded"
881                     );
882                 }
883                 //when sell
884                 else if (
885                     automatedMarketMakerPairs[to] &&
886                     !_isExcludedMaxTransactionAmount[from]
887                 ) {
888                     require(
889                         amount <= maxTransactionAmount,
890                         "Sell transfer amount exceeds the maxTransactionAmount."
891                     );
892                 } else if (!_isExcludedMaxTransactionAmount[to]) {
893                     require(
894                         amount + balanceOf(to) <= maxWallet,
895                         "Max wallet exceeded"
896                     );
897                 }
898             }
899         }
900 
901         uint256 contractTokenBalance = balanceOf(address(this));
902 
903         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
904 
905         if (
906             canSwap &&
907             swapEnabled &&
908             !swapping &&
909             !automatedMarketMakerPairs[from] &&
910             !_isExcludedFromFees[from] &&
911             !_isExcludedFromFees[to]
912         ) {
913             swapping = true;
914 
915             swapBack();
916 
917             swapping = false;
918         }
919 
920         if (
921             !swapping &&
922             automatedMarketMakerPairs[to] &&
923             lpBurnEnabled &&
924             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
925             !_isExcludedFromFees[from]
926         ) {
927             autoBurnLiquidityPairTokens();
928         }
929 
930         bool takeFee = !swapping;
931 
932         // if any account belongs to _isExcludedFromFee account then remove the fee
933         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
934             takeFee = false;
935         }
936 
937         uint256 fees = 0;
938         // only take fees on buys/sells, do not take on wallet transfers
939         if (takeFee) {
940             // on sell
941             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
942                 fees = amount.mul(sellTotalFees).div(100);
943                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
944                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
945                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
946             }
947             // on buy
948             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
949                 fees = amount.mul(buyTotalFees).div(100);
950                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
951                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
952                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
953             }
954 
955             if (fees > 0) {
956                 super._transfer(from, address(this), fees);
957             }
958 
959             amount -= fees;
960         }
961 
962         super._transfer(from, to, amount);
963     }
964 
965     function swapTokensForEth(uint256 tokenAmount) private {
966         // generate the uniswap pair path of token -> weth
967         address[] memory path = new address[](2);
968         path[0] = address(this);
969         path[1] = uniswapV2Router.WETH();
970 
971         _approve(address(this), address(uniswapV2Router), tokenAmount);
972 
973         // make the swap
974         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
975             tokenAmount,
976             0, // accept any amount of ETH
977             path,
978             address(this),
979             block.timestamp
980         );
981     }
982 
983     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
984         // approve token transfer to cover all possible scenarios
985         _approve(address(this), address(uniswapV2Router), tokenAmount);
986 
987         // add the liquidity
988         uniswapV2Router.addLiquidityETH{value: ethAmount}(
989             address(this),
990             tokenAmount,
991             0, // slippage is unavoidable
992             0, // slippage is unavoidable
993             deadAddress,
994             block.timestamp
995         );
996     }
997 
998     function swapBack() private {
999         uint256 contractBalance = balanceOf(address(this));
1000         uint256 totalTokensToSwap = tokensForLiquidity +
1001             tokensForMarketing +
1002             tokensForDev;
1003         bool success;
1004 
1005         if (contractBalance == 0 || totalTokensToSwap == 0) {
1006             return;
1007         }
1008 
1009         if (contractBalance > swapTokensAtAmount * 20) {
1010             contractBalance = swapTokensAtAmount * 20;
1011         }
1012 
1013         // Halve the amount of liquidity tokens
1014         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1015             totalTokensToSwap /
1016             2;
1017         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1018 
1019         uint256 initialETHBalance = address(this).balance;
1020 
1021         swapTokensForEth(amountToSwapForETH);
1022 
1023         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1024 
1025         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1026             totalTokensToSwap
1027         );
1028         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1029 
1030         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1031 
1032         tokensForLiquidity = 0;
1033         tokensForMarketing = 0;
1034         tokensForDev = 0;
1035 
1036         (success, ) = address(devWallet).call{value: ethForDev}("");
1037 
1038         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1039             addLiquidity(liquidityTokens, ethForLiquidity);
1040             emit SwapAndLiquify(
1041                 amountToSwapForETH,
1042                 ethForLiquidity,
1043                 tokensForLiquidity
1044             );
1045         }
1046 
1047         (success, ) = address(marketingWallet).call{
1048             value: address(this).balance
1049         }("");
1050     }
1051 
1052     function setAutoLPBurnSettings(
1053         uint256 _frequencyInSeconds,
1054         uint256 _percent,
1055         bool _Enabled
1056     ) external onlyOwner {
1057         require(
1058             _frequencyInSeconds >= 600,
1059             "cannot set buyback more often than every 10 minutes"
1060         );
1061         require(
1062             _percent <= 1000 && _percent >= 0,
1063             "Must set auto LP burn percent between 0% and 10%"
1064         );
1065         lpBurnFrequency = _frequencyInSeconds;
1066         percentForLPBurn = _percent;
1067         lpBurnEnabled = _Enabled;
1068     }
1069 
1070     function autoBurnLiquidityPairTokens() internal returns (bool) {
1071         lastLpBurnTime = block.timestamp;
1072 
1073         // get balance of liquidity pair
1074         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1075 
1076         // calculate amount to burn
1077         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1078             10000
1079         );
1080 
1081         // pull tokens from pancakePair liquidity and move to dead address permanently
1082         if (amountToBurn > 0) {
1083             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1084         }
1085 
1086         //sync price since this is not in a swap transaction!
1087         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1088         pair.sync();
1089         emit AutoNukeLP();
1090         return true;
1091     }
1092 
1093     function manualBurnLiquidityPairTokens(uint256 percent)
1094         external
1095         onlyOwner
1096         returns (bool)
1097     {
1098         require(
1099             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1100             "Must wait for cooldown to finish"
1101         );
1102         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1103         lastManualLpBurnTime = block.timestamp;
1104 
1105         // get balance of liquidity pair
1106         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1107 
1108         // calculate amount to burn
1109         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1110 
1111         // pull tokens from pancakePair liquidity and move to dead address permanently
1112         if (amountToBurn > 0) {
1113             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1114         }
1115 
1116         //sync price since this is not in a swap transaction!
1117         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1118         pair.sync();
1119         emit ManualNukeLP();
1120         return true;
1121     }
1122 }