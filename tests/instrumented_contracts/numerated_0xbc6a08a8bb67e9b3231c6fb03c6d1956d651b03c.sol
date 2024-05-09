1 /**
2 https://t.me/TheAlgorithmERC
3 */
4 // SPDX-License-Identifier: MIT
5  
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8  
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
39  
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43  
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48  
49  
50     function _transferOwnership(address newOwner) internal virtual {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56  
57  
58 interface IERC20 {
59  
60     function totalSupply() external view returns (uint256);
61  
62     function balanceOf(address account) external view returns (uint256);
63  
64  
65     function transfer(address recipient, uint256 amount) external returns (bool);
66  
67  
68     function allowance(address owner, address spender) external view returns (uint256);
69  
70     function approve(address spender, uint256 amount) external returns (bool);
71  
72  
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78  
79  
80     event Transfer(address indexed from, address indexed to, uint256 value);
81  
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84  
85  
86 interface IERC20Metadata is IERC20 {
87  
88     function name() external view returns (string memory);
89  
90     function symbol() external view returns (string memory);
91  
92     function decimals() external view returns (uint8);
93 }
94  
95  
96 contract ERC20 is Context, IERC20, IERC20Metadata {
97     mapping(address => uint256) private _balances;
98  
99     mapping(address => mapping(address => uint256)) private _allowances;
100  
101     uint256 private _totalSupply;
102  
103     string private _name;
104     string private _symbol;
105  
106  
107  
108     constructor(string memory name_, string memory symbol_) {
109         _name = name_;
110         _symbol = symbol_;
111     }
112  
113  
114     function name() public view virtual override returns (string memory) {
115         return _name;
116     }
117  
118  
119     function symbol() public view virtual override returns (string memory) {
120         return _symbol;
121     }
122  
123  
124     function decimals() public view virtual override returns (uint8) {
125         return 18;
126     }
127  
128  
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132  
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136  
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141  
142  
143     function allowance(address owner, address spender) public view virtual override returns (uint256) {
144         return _allowances[owner][spender];
145     }
146  
147     function approve(address spender, uint256 amount) public virtual override returns (bool) {
148         _approve(_msgSender(), spender, amount);
149         return true;
150     }
151  
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) public virtual override returns (bool) {
157         _transfer(sender, recipient, amount);
158  
159         uint256 currentAllowance = _allowances[sender][_msgSender()];
160         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
161         unchecked {
162             _approve(sender, _msgSender(), currentAllowance - amount);
163         }
164  
165         return true;
166     }
167  
168     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
170         return true;
171     }
172  
173     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
174         uint256 currentAllowance = _allowances[_msgSender()][spender];
175         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
176         unchecked {
177             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
178         }
179  
180         return true;
181     }
182  
183     function _transfer(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) internal virtual {
188         require(sender != address(0), "ERC20: transfer from the zero address");
189         require(recipient != address(0), "ERC20: transfer to the zero address");
190  
191         _beforeTokenTransfer(sender, recipient, amount);
192  
193         uint256 senderBalance = _balances[sender];
194         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
195         unchecked {
196             _balances[sender] = senderBalance - amount;
197         }
198         _balances[recipient] += amount;
199  
200         emit Transfer(sender, recipient, amount);
201  
202         _afterTokenTransfer(sender, recipient, amount);
203     }
204  
205     function _mint(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: mint to the zero address");
207  
208         _beforeTokenTransfer(address(0), account, amount);
209  
210         _totalSupply += amount;
211         _balances[account] += amount;
212         emit Transfer(address(0), account, amount);
213  
214         _afterTokenTransfer(address(0), account, amount);
215     }
216  
217     function _burn(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: burn from the zero address");
219  
220         _beforeTokenTransfer(account, address(0), amount);
221  
222         uint256 accountBalance = _balances[account];
223         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
224         unchecked {
225             _balances[account] = accountBalance - amount;
226         }
227         _totalSupply -= amount;
228  
229         emit Transfer(account, address(0), amount);
230  
231         _afterTokenTransfer(account, address(0), amount);
232     }
233  
234     function _approve(
235         address owner,
236         address spender,
237         uint256 amount
238     ) internal virtual {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241  
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245  
246     function _beforeTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251  
252     function _afterTokenTransfer(
253         address from,
254         address to,
255         uint256 amount
256     ) internal virtual {}
257 }
258  
259  
260 library SafeMath {
261  
262     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             uint256 c = a + b;
265             if (c < a) return (false, 0);
266             return (true, c);
267         }
268     }
269  
270     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (b > a) return (false, 0);
273             return (true, a - b);
274         }
275     }
276  
277  
278     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (a == 0) return (true, 0);
281             uint256 c = a * b;
282             if (c / a != b) return (false, 0);
283             return (true, c);
284         }
285     }
286  
287     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b == 0) return (false, 0);
290             return (true, a / b);
291         }
292     }
293  
294     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         unchecked {
296             if (b == 0) return (false, 0);
297             return (true, a % b);
298         }
299     }
300  
301  
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a + b;
304     }
305  
306     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a - b;
308     }
309  
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313  
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a / b;
316     }
317  
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a % b;
320     }
321  
322     function sub(
323         uint256 a,
324         uint256 b,
325         string memory errorMessage
326     ) internal pure returns (uint256) {
327         unchecked {
328             require(b <= a, errorMessage);
329             return a - b;
330         }
331     }
332  
333     function div(
334         uint256 a,
335         uint256 b,
336         string memory errorMessage
337     ) internal pure returns (uint256) {
338         unchecked {
339             require(b > 0, errorMessage);
340             return a / b;
341         }
342     }
343  
344  
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         unchecked {
351             require(b > 0, errorMessage);
352             return a % b;
353         }
354     }
355 }
356  
357  
358 interface IUniswapV2Factory {
359     event PairCreated(
360         address indexed token0,
361         address indexed token1,
362         address pair,
363         uint256
364     );
365  
366     function feeTo() external view returns (address);
367  
368     function feeToSetter() external view returns (address);
369  
370     function getPair(address tokenA, address tokenB)
371         external
372         view
373         returns (address pair);
374  
375     function allPairs(uint256) external view returns (address pair);
376  
377     function allPairsLength() external view returns (uint256);
378  
379     function createPair(address tokenA, address tokenB)
380         external
381         returns (address pair);
382  
383     function setFeeTo(address) external;
384  
385     function setFeeToSetter(address) external;
386 }
387  
388  
389 interface IUniswapV2Pair {
390     event Approval(
391         address indexed owner,
392         address indexed spender,
393         uint256 value
394     );
395     event Transfer(address indexed from, address indexed to, uint256 value);
396  
397     function name() external pure returns (string memory);
398  
399     function symbol() external pure returns (string memory);
400  
401     function decimals() external pure returns (uint8);
402  
403     function totalSupply() external view returns (uint256);
404  
405     function balanceOf(address owner) external view returns (uint256);
406  
407     function allowance(address owner, address spender)
408         external
409         view
410         returns (uint256);
411  
412     function approve(address spender, uint256 value) external returns (bool);
413  
414     function transfer(address to, uint256 value) external returns (bool);
415  
416     function transferFrom(
417         address from,
418         address to,
419         uint256 value
420     ) external returns (bool);
421  
422     function DOMAIN_SEPARATOR() external view returns (bytes32);
423  
424     function PERMIT_TYPEHASH() external pure returns (bytes32);
425  
426     function nonces(address owner) external view returns (uint256);
427  
428     function permit(
429         address owner,
430         address spender,
431         uint256 value,
432         uint256 deadline,
433         uint8 v,
434         bytes32 r,
435         bytes32 s
436     ) external;
437  
438     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
439     event Burn(
440         address indexed sender,
441         uint256 amount0,
442         uint256 amount1,
443         address indexed to
444     );
445     event Swap(
446         address indexed sender,
447         uint256 amount0In,
448         uint256 amount1In,
449         uint256 amount0Out,
450         uint256 amount1Out,
451         address indexed to
452     );
453     event Sync(uint112 reserve0, uint112 reserve1);
454  
455     function MINIMUM_LIQUIDITY() external pure returns (uint256);
456  
457     function factory() external view returns (address);
458  
459     function token0() external view returns (address);
460  
461     function token1() external view returns (address);
462  
463     function getReserves()
464         external
465         view
466         returns (
467             uint112 reserve0,
468             uint112 reserve1,
469             uint32 blockTimestampLast
470         );
471  
472     function price0CumulativeLast() external view returns (uint256);
473  
474     function price1CumulativeLast() external view returns (uint256);
475  
476     function kLast() external view returns (uint256);
477  
478     function mint(address to) external returns (uint256 liquidity);
479  
480     function burn(address to)
481         external
482         returns (uint256 amount0, uint256 amount1);
483  
484     function swap(
485         uint256 amount0Out,
486         uint256 amount1Out,
487         address to,
488         bytes calldata data
489     ) external;
490  
491     function skim(address to) external;
492  
493     function sync() external;
494  
495     function initialize(address, address) external;
496 }
497  
498  
499 interface IUniswapV2Router02 {
500     function factory() external pure returns (address);
501  
502     function WETH() external pure returns (address);
503  
504     function addLiquidity(
505         address tokenA,
506         address tokenB,
507         uint256 amountADesired,
508         uint256 amountBDesired,
509         uint256 amountAMin,
510         uint256 amountBMin,
511         address to,
512         uint256 deadline
513     )
514         external
515         returns (
516             uint256 amountA,
517             uint256 amountB,
518             uint256 liquidity
519         );
520  
521     function addLiquidityETH(
522         address token,
523         uint256 amountTokenDesired,
524         uint256 amountTokenMin,
525         uint256 amountETHMin,
526         address to,
527         uint256 deadline
528     )
529         external
530         payable
531         returns (
532             uint256 amountToken,
533             uint256 amountETH,
534             uint256 liquidity
535         );
536  
537     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
538         uint256 amountIn,
539         uint256 amountOutMin,
540         address[] calldata path,
541         address to,
542         uint256 deadline
543     ) external;
544  
545     function swapExactETHForTokensSupportingFeeOnTransferTokens(
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline
550     ) external payable;
551  
552     function swapExactTokensForETHSupportingFeeOnTransferTokens(
553         uint256 amountIn,
554         uint256 amountOutMin,
555         address[] calldata path,
556         address to,
557         uint256 deadline
558     ) external;
559 }
560  
561  
562  
563 contract ALGO is ERC20, Ownable {
564     using SafeMath for uint256;
565  
566     IUniswapV2Router02 public immutable uniswapV2Router;
567     address public immutable uniswapV2Pair;
568     address public constant deadAddress = address(0xdead);
569  
570     bool private swapping;
571  
572     address private marketingWallet;
573     address private developmentWallet;
574  
575     uint256 public percentForLPBurn = 0; 
576     bool public lpBurnEnabled = false;
577     uint256 public lpBurnFrequency = 3600 seconds;
578     uint256 public lastLpBurnTime;
579  
580     uint256 public maxTransactionAmount;
581     uint256 public swapTokensAtAmount;
582     uint256 public maxWallet;
583  
584     bool public limitsInEffect = true;
585     bool public tradingActive = true;
586     bool public swapEnabled = true;
587  
588     uint256 public manualBurnFrequency = 30 minutes;
589     uint256 public lastManualLpBurnTime;
590  
591  
592  
593     mapping(address => uint256) private _holderLastTransferTimestamp; 
594     bool public transferDelayEnabled = true;
595  
596     uint256 public buyTotalFees;
597     uint256 public buyMarketingFee;
598     uint256 public buyLiquidityFee;
599     uint256 public buyDevelopmentFee;
600  
601     uint256 public sellTotalFees;
602     uint256 public sellMarketingFee;
603     uint256 public sellLiquidityFee;
604     uint256 public sellDevelopmentFee;
605  
606     uint256 public tokensForMarketing;
607     uint256 public tokensForLiquidity;
608     uint256 public tokensForDev;
609  
610     mapping(address => bool) private _isExcludedFromFees;
611     mapping(address => bool) public _isExcludedMaxTransactionAmount;
612  
613     mapping(address => bool) public automatedMarketMakerPairs;
614  
615     event UpdateUniswapV2Router(
616         address indexed newAddress,
617         address indexed oldAddress
618     );
619  
620     event ExcludeFromFees(address indexed account, bool isExcluded);
621  
622     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
623  
624     event marketingWalletUpdated(
625         address indexed newWallet,
626         address indexed oldWallet
627     );
628  
629     event developmentWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633  
634     event SwapAndLiquify(
635         uint256 tokensSwapped,
636         uint256 ethReceived,
637         uint256 tokensIntoLiquidity
638     );
639  
640     event AutoNukeLP();
641  
642     event ManualNukeLP();
643  
644     constructor() ERC20("The-Algorithm", "ALGO") {
645         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
646             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
647         );
648  
649         excludeFromMaxTransaction(address(_uniswapV2Router), true);
650         uniswapV2Router = _uniswapV2Router;
651  
652         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
653             .createPair(address(this), _uniswapV2Router.WETH());
654         excludeFromMaxTransaction(address(uniswapV2Pair), true);
655         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
656  
657         uint256 _buyMarketingFee = 25;
658         uint256 _buyLiquidityFee = 0;
659         uint256 _buyDevelopmentFee = 0;
660  
661         uint256 _sellMarketingFee = 99;
662         uint256 _sellLiquidityFee = 0;
663         uint256 _sellDevelopmentFee = 0;
664  
665         uint256 totalSupply = 1_000_000_000 * 1e18;
666  
667         maxTransactionAmount = 1_000_000_000 * 1e18; 
668         maxWallet = 20_000_000 * 1e18; 
669         swapTokensAtAmount = (totalSupply * 10) / 10000;
670  
671         buyMarketingFee = _buyMarketingFee;
672         buyLiquidityFee = _buyLiquidityFee;
673         buyDevelopmentFee = _buyDevelopmentFee;
674         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
675  
676         sellMarketingFee = _sellMarketingFee;
677         sellLiquidityFee = _sellLiquidityFee;
678         sellDevelopmentFee = _sellDevelopmentFee;
679         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
680  
681         marketingWallet = address(0x570647312a8CB0587c6C26D1b1519d614997Bf93); 
682         developmentWallet = address(0x570647312a8CB0587c6C26D1b1519d614997Bf93); 
683  
684         excludeFromFees(owner(), true);
685         excludeFromFees(address(this), true);
686         excludeFromFees(address(0xdead), true);
687  
688         excludeFromMaxTransaction(owner(), true);
689         excludeFromMaxTransaction(address(this), true);
690         excludeFromMaxTransaction(address(0xdead), true);
691  
692         _mint(msg.sender, totalSupply);
693     }
694  
695     receive() external payable {}
696  
697     function enableTrade() external onlyOwner {
698         tradingActive = true;
699         swapEnabled = true;
700         lastLpBurnTime = block.timestamp;
701     }
702  
703     function removeLimits() external onlyOwner returns (bool) {
704         limitsInEffect = false;
705         return true;
706     }
707  
708     function disableTransferDelay() external onlyOwner returns (bool) {
709         transferDelayEnabled = false;
710         return true;
711     }
712  
713     function updateSwapTokensAtAmount(uint256 newAmount)
714         external
715         onlyOwner
716         returns (bool)
717     {
718         require(
719             newAmount >= (totalSupply() * 1) / 100000,
720             "Swap amount cannot be lower than 0.001% total supply."
721         );
722         require(
723             newAmount <= (totalSupply() * 5) / 1000,
724             "Swap amount cannot be higher than 0.5% total supply."
725         );
726         swapTokensAtAmount = newAmount;
727         return true;
728     }
729  
730     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
731         require(
732             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
733             "Cannot set maxTransactionAmount lower than 0.1%"
734         );
735         maxTransactionAmount = newNum * (10**18);
736     }
737  
738     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
739         require(
740             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
741             "Cannot set maxWallet lower than 0.5%"
742         );
743         maxWallet = newNum * (10**18);
744     }
745  
746     function excludeFromMaxTransaction(address updAds, bool isEx)
747         public
748         onlyOwner
749     {
750         _isExcludedMaxTransactionAmount[updAds] = isEx;
751     }
752  
753     function updateSwapEnabled(bool enabled) external onlyOwner {
754         swapEnabled = enabled;
755     }
756  
757     function updateBuyFees(
758         uint256 _marketingFee,
759         uint256 _liquidityFee,
760         uint256 _developmentFee
761     ) external onlyOwner {
762         buyMarketingFee = _marketingFee;
763         buyLiquidityFee = _liquidityFee;
764         buyDevelopmentFee = _developmentFee;
765         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
766     }
767  
768     function updateSellFees(
769         uint256 _marketingFee,
770         uint256 _liquidityFee,
771         uint256 _developmentFee
772     ) external onlyOwner {
773         sellMarketingFee = _marketingFee;
774         sellLiquidityFee = _liquidityFee;
775         sellDevelopmentFee = _developmentFee;
776         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
777     }
778  
779     function excludeFromFees(address account, bool excluded) public onlyOwner {
780         _isExcludedFromFees[account] = excluded;
781         emit ExcludeFromFees(account, excluded);
782     }
783  
784     function setAutomatedMarketMakerPair(address pair, bool value)
785         public
786         onlyOwner
787     {
788         require(
789             pair != uniswapV2Pair,
790             "The pair cannot be removed from automatedMarketMakerPairs"
791         );
792  
793         _setAutomatedMarketMakerPair(pair, value);
794     }
795  
796     function _setAutomatedMarketMakerPair(address pair, bool value) private {
797         automatedMarketMakerPairs[pair] = value;
798  
799         emit SetAutomatedMarketMakerPair(pair, value);
800     }
801  
802     function updateMarketingWalletInfo(address newMarketingWallet)
803         external
804         onlyOwner
805     {
806         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
807         marketingWallet = newMarketingWallet;
808     }
809  
810     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
811         emit developmentWalletUpdated(newWallet, developmentWallet);
812         developmentWallet = newWallet;
813     }
814  
815     function isExcludedFromFees(address account) public view returns (bool) {
816         return _isExcludedFromFees[account];
817     }
818  
819     event BoughtEarly(address indexed sniper);
820  
821     function _transfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal override {
826         require(from != address(0), "ERC20: transfer from the zero address");
827         require(to != address(0), "ERC20: transfer to the zero address");
828  
829         if (amount == 0) {
830             super._transfer(from, to, 0);
831             return;
832         }
833  
834         if (limitsInEffect) {
835             if (
836                 from != owner() &&
837                 to != owner() &&
838                 to != address(0) &&
839                 to != address(0xdead) &&
840                 !swapping
841             ) {
842                 if (!tradingActive) {
843                     require(
844                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
845                         "Trading is not active."
846                     );
847                 }
848  
849                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
850                 if (transferDelayEnabled) {
851                     if (
852                         to != owner() &&
853                         to != address(uniswapV2Router) &&
854                         to != address(uniswapV2Pair)
855                     ) {
856                         require(
857                             _holderLastTransferTimestamp[tx.origin] <
858                                 block.number,
859                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
860                         );
861                         _holderLastTransferTimestamp[tx.origin] = block.number;
862                     }
863                 }
864  
865                 //when buy
866                 if (
867                     automatedMarketMakerPairs[from] &&
868                     !_isExcludedMaxTransactionAmount[to]
869                 ) {
870                     require(
871                         amount <= maxTransactionAmount,
872                         "Buy transfer amount exceeds the maxTransactionAmount."
873                     );
874                     require(
875                         amount + balanceOf(to) <= maxWallet,
876                         "Max wallet exceeded"
877                     );
878                 }
879                 //when sell
880                 else if (
881                     automatedMarketMakerPairs[to] &&
882                     !_isExcludedMaxTransactionAmount[from]
883                 ) {
884                     require(
885                         amount <= maxTransactionAmount,
886                         "Sell transfer amount exceeds the maxTransactionAmount."
887                     );
888                 } else if (!_isExcludedMaxTransactionAmount[to]) {
889                     require(
890                         amount + balanceOf(to) <= maxWallet,
891                         "Max wallet exceeded"
892                     );
893                 }
894             }
895         }
896  
897         uint256 contractTokenBalance = balanceOf(address(this));
898  
899         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
900  
901         if (
902             canSwap &&
903             swapEnabled &&
904             !swapping &&
905             !automatedMarketMakerPairs[from] &&
906             !_isExcludedFromFees[from] &&
907             !_isExcludedFromFees[to]
908         ) {
909             swapping = true;
910  
911             swapBack();
912  
913             swapping = false;
914         }
915  
916         if (
917             !swapping &&
918             automatedMarketMakerPairs[to] &&
919             lpBurnEnabled &&
920             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
921             !_isExcludedFromFees[from]
922         ) {
923             autoBurnLiquidityPairTokens();
924         }
925  
926         bool takeFee = !swapping;
927  
928         // if any account belongs to _isExcludedFromFee account then remove the fee
929         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
930             takeFee = false;
931         }
932  
933         uint256 fees = 0;
934         // only take fees on buys/sells, do not take on wallet transfers
935         if (takeFee) {
936             // on sell
937             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
938                 fees = amount.mul(sellTotalFees).div(100);
939                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
940                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
941                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
942             }
943             // on buy
944             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
945                 fees = amount.mul(buyTotalFees).div(100);
946                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
947                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
948                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
949             }
950  
951             if (fees > 0) {
952                 super._transfer(from, address(this), fees);
953             }
954  
955             amount -= fees;
956         }
957  
958         super._transfer(from, to, amount);
959     }
960  
961     function swapTokensForEth(uint256 tokenAmount) private {
962         // generate the uniswap pair path of token -> weth
963         address[] memory path = new address[](2);
964         path[0] = address(this);
965         path[1] = uniswapV2Router.WETH();
966  
967         _approve(address(this), address(uniswapV2Router), tokenAmount);
968  
969         // make the swap
970         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
971             tokenAmount,
972             0, // accept any amount of ETH
973             path,
974             address(this),
975             block.timestamp
976         );
977     }
978  
979     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
980         // approve token transfer to cover all possible scenarios
981         _approve(address(this), address(uniswapV2Router), tokenAmount);
982  
983         // add the liquidity
984         uniswapV2Router.addLiquidityETH{value: ethAmount}(
985             address(this),
986             tokenAmount,
987             0, // slippage is unavoidable
988             0, // slippage is unavoidable
989             deadAddress,
990             block.timestamp
991         );
992     }
993  
994     function swapBack() private {
995         uint256 contractBalance = balanceOf(address(this));
996         uint256 totalTokensToSwap = tokensForLiquidity +
997             tokensForMarketing +
998             tokensForDev;
999         bool success;
1000  
1001         if (contractBalance == 0 || totalTokensToSwap == 0) {
1002             return;
1003         }
1004  
1005         if (contractBalance > swapTokensAtAmount * 20) {
1006             contractBalance = swapTokensAtAmount * 20;
1007         }
1008  
1009         // Halve the amount of liquidity tokens
1010         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1011             totalTokensToSwap /
1012             2;
1013         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1014  
1015         uint256 initialETHBalance = address(this).balance;
1016  
1017         swapTokensForEth(amountToSwapForETH);
1018  
1019         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1020  
1021         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1022             totalTokensToSwap
1023         );
1024         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1025  
1026         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1027  
1028         tokensForLiquidity = 0;
1029         tokensForMarketing = 0;
1030         tokensForDev = 0;
1031  
1032         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1033  
1034         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1035             addLiquidity(liquidityTokens, ethForLiquidity);
1036             emit SwapAndLiquify(
1037                 amountToSwapForETH,
1038                 ethForLiquidity,
1039                 tokensForLiquidity
1040             );
1041         }
1042  
1043         (success, ) = address(marketingWallet).call{
1044             value: address(this).balance
1045         }("");
1046     }
1047  
1048     function setAutoLPBurnSettings(
1049         uint256 _frequencyInSeconds,
1050         uint256 _percent,
1051         bool _Enabled
1052     ) external onlyOwner {
1053         require(
1054             _frequencyInSeconds >= 600,
1055             "cannot set buyback more often than every 10 minutes"
1056         );
1057         require(
1058             _percent <= 1000 && _percent >= 0,
1059             "Must set auto LP burn percent between 0% and 10%"
1060         );
1061         lpBurnFrequency = _frequencyInSeconds;
1062         percentForLPBurn = _percent;
1063         lpBurnEnabled = _Enabled;
1064     }
1065  
1066     function autoBurnLiquidityPairTokens() internal returns (bool) {
1067         lastLpBurnTime = block.timestamp;
1068  
1069         // get balance of liquidity pair
1070         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1071  
1072         // calculate amount to burn
1073         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1074             10000
1075         );
1076  
1077         // pull tokens from pancakePair liquidity and move to dead address permanently
1078         if (amountToBurn > 0) {
1079             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1080         }
1081  
1082         //sync price since this is not in a swap transaction!
1083         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1084         pair.sync();
1085         emit AutoNukeLP();
1086         return true;
1087     }
1088  
1089     function manualBurnLiquidityPairTokens(uint256 percent)
1090         external
1091         onlyOwner
1092         returns (bool)
1093     {
1094         require(
1095             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1096             "Must wait for cooldown to finish"
1097         );
1098         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1099         lastManualLpBurnTime = block.timestamp;
1100  
1101         // get balance of liquidity pair
1102         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1103  
1104         // calculate amount to burn
1105         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1106  
1107         // pull tokens from pancakePair liquidity and move to dead address permanently
1108         if (amountToBurn > 0) {
1109             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1110         }
1111  
1112         //sync price since this is not in a swap transaction!
1113         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1114         pair.sync();
1115         emit ManualNukeLP();
1116         return true;
1117     }
1118 }