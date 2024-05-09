1 /*
2 
3 https://t.me/pepethreeportal
4 
5 */
6 
7 // SPDX-License-Identifier: UNLICENSED
8 
9 pragma solidity ^0.8.20;
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
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
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
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101 
102     constructor(string memory name_, string memory symbol_) {
103         _name = name_;
104         _symbol = symbol_;
105     }
106 
107 
108     function name() public view virtual override returns (string memory) {
109         return _name;
110     }
111 
112     function symbol() public view virtual override returns (string memory) {
113         return _symbol;
114     }
115 
116     function decimals() public view virtual override returns (uint8) {
117         return 18;
118     }
119 
120     function totalSupply() public view virtual override returns (uint256) {
121         return _totalSupply;
122     }
123 
124     function balanceOf(address account) public view virtual override returns (uint256) {
125         return _balances[account];
126     }
127 
128     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
129         _transfer(_msgSender(), recipient, amount);
130         return true;
131     }
132 
133     function allowance(address owner, address spender) public view virtual override returns (uint256) {
134         return _allowances[owner][spender];
135     }
136 
137     function approve(address spender, uint256 amount) public virtual override returns (bool) {
138         _approve(_msgSender(), spender, amount);
139         return true;
140     }
141 
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) public virtual override returns (bool) {
147         _transfer(sender, recipient, amount);
148 
149         uint256 currentAllowance = _allowances[sender][_msgSender()];
150         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
151         unchecked {
152             _approve(sender, _msgSender(), currentAllowance - amount);
153         }
154 
155         return true;
156     }
157 
158     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
159         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
160         return true;
161     }
162 
163     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
164         uint256 currentAllowance = _allowances[_msgSender()][spender];
165         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
166         unchecked {
167             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
168         }
169 
170         return true;
171     }
172 
173     function _transfer(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) internal virtual {
178         require(sender != address(0), "ERC20: transfer from the zero address");
179         require(recipient != address(0), "ERC20: transfer to the zero address");
180 
181         _beforeTokenTransfer(sender, recipient, amount);
182 
183         uint256 senderBalance = _balances[sender];
184         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
185         unchecked {
186             _balances[sender] = senderBalance - amount;
187         }
188         _balances[recipient] += amount;
189 
190         emit Transfer(sender, recipient, amount);
191 
192         _afterTokenTransfer(sender, recipient, amount);
193     }
194 
195     function _mint(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: mint to the zero address");
197 
198         _beforeTokenTransfer(address(0), account, amount);
199 
200         _totalSupply += amount;
201         _balances[account] += amount;
202         emit Transfer(address(0), account, amount);
203 
204         _afterTokenTransfer(address(0), account, amount);
205     }
206 
207     function _burn(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: burn from the zero address");
209 
210         _beforeTokenTransfer(account, address(0), amount);
211 
212         uint256 accountBalance = _balances[account];
213         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
214         unchecked {
215             _balances[account] = accountBalance - amount;
216         }
217         _totalSupply -= amount;
218 
219         emit Transfer(account, address(0), amount);
220 
221         _afterTokenTransfer(account, address(0), amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _beforeTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 
242     function _afterTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 }
248 
249 library SafeMath {
250 
251     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             uint256 c = a + b;
254             if (c < a) return (false, 0);
255             return (true, c);
256         }
257     }
258 
259     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b > a) return (false, 0);
262             return (true, a - b);
263         }
264     }
265 
266     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             if (a == 0) return (true, 0);
269             uint256 c = a * b;
270             if (c / a != b) return (false, 0);
271             return (true, c);
272         }
273     }
274 
275     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (b == 0) return (false, 0);
278             return (true, a / b);
279         }
280     }
281 
282     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         unchecked {
284             if (b == 0) return (false, 0);
285             return (true, a % b);
286         }
287     }
288 
289     function add(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a + b;
291     }
292 
293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a - b;
295     }
296 
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a * b;
299     }
300 
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a / b;
303     }
304 
305     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a % b;
307     }
308 
309     function sub(
310         uint256 a,
311         uint256 b,
312         string memory errorMessage
313     ) internal pure returns (uint256) {
314         unchecked {
315             require(b <= a, errorMessage);
316             return a - b;
317         }
318     }
319 
320     function div(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b > 0, errorMessage);
327             return a / b;
328         }
329     }
330 
331     function mod(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a % b;
339         }
340     }
341 }
342 
343 interface IUniswapV2Factory {
344     event PairCreated(
345         address indexed token0,
346         address indexed token1,
347         address pair,
348         uint256
349     );
350 
351     function feeTo() external view returns (address);
352 
353     function feeToSetter() external view returns (address);
354 
355     function getPair(address tokenA, address tokenB)
356         external
357         view
358         returns (address pair);
359 
360     function allPairs(uint256) external view returns (address pair);
361 
362     function allPairsLength() external view returns (uint256);
363 
364     function createPair(address tokenA, address tokenB)
365         external
366         returns (address pair);
367 
368     function setFeeTo(address) external;
369 
370     function setFeeToSetter(address) external;
371 }
372 
373 interface IUniswapV2Pair {
374     event Approval(
375         address indexed owner,
376         address indexed spender,
377         uint256 value
378     );
379     event Transfer(address indexed from, address indexed to, uint256 value);
380 
381     function name() external pure returns (string memory);
382 
383     function symbol() external pure returns (string memory);
384 
385     function decimals() external pure returns (uint8);
386 
387     function totalSupply() external view returns (uint256);
388 
389     function balanceOf(address owner) external view returns (uint256);
390 
391     function allowance(address owner, address spender)
392         external
393         view
394         returns (uint256);
395 
396     function approve(address spender, uint256 value) external returns (bool);
397 
398     function transfer(address to, uint256 value) external returns (bool);
399 
400     function transferFrom(
401         address from,
402         address to,
403         uint256 value
404     ) external returns (bool);
405 
406     function DOMAIN_SEPARATOR() external view returns (bytes32);
407 
408     function PERMIT_TYPEHASH() external pure returns (bytes32);
409 
410     function nonces(address owner) external view returns (uint256);
411 
412     function permit(
413         address owner,
414         address spender,
415         uint256 value,
416         uint256 deadline,
417         uint8 v,
418         bytes32 r,
419         bytes32 s
420     ) external;
421 
422     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
423     event Burn(
424         address indexed sender,
425         uint256 amount0,
426         uint256 amount1,
427         address indexed to
428     );
429     event Swap(
430         address indexed sender,
431         uint256 amount0In,
432         uint256 amount1In,
433         uint256 amount0Out,
434         uint256 amount1Out,
435         address indexed to
436     );
437     event Sync(uint112 reserve0, uint112 reserve1);
438 
439     function MINIMUM_LIQUIDITY() external pure returns (uint256);
440 
441     function factory() external view returns (address);
442 
443     function token0() external view returns (address);
444 
445     function token1() external view returns (address);
446 
447     function getReserves()
448         external
449         view
450         returns (
451             uint112 reserve0,
452             uint112 reserve1,
453             uint32 blockTimestampLast
454         );
455 
456     function price0CumulativeLast() external view returns (uint256);
457 
458     function price1CumulativeLast() external view returns (uint256);
459 
460     function kLast() external view returns (uint256);
461 
462     function mint(address to) external returns (uint256 liquidity);
463 
464     function burn(address to)
465         external
466         returns (uint256 amount0, uint256 amount1);
467 
468     function swap(
469         uint256 amount0Out,
470         uint256 amount1Out,
471         address to,
472         bytes calldata data
473     ) external;
474 
475     function skim(address to) external;
476 
477     function sync() external;
478 
479     function initialize(address, address) external;
480 }
481 
482 interface IUniswapV2Router02 {
483     function factory() external pure returns (address);
484 
485     function WETH() external pure returns (address);
486 
487     function addLiquidity(
488         address tokenA,
489         address tokenB,
490         uint256 amountADesired,
491         uint256 amountBDesired,
492         uint256 amountAMin,
493         uint256 amountBMin,
494         address to,
495         uint256 deadline
496     )
497         external
498         returns (
499             uint256 amountA,
500             uint256 amountB,
501             uint256 liquidity
502         );
503 
504     function addLiquidityETH(
505         address token,
506         uint256 amountTokenDesired,
507         uint256 amountTokenMin,
508         uint256 amountETHMin,
509         address to,
510         uint256 deadline
511     )
512         external
513         payable
514         returns (
515             uint256 amountToken,
516             uint256 amountETH,
517             uint256 liquidity
518         );
519 
520     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
521         uint256 amountIn,
522         uint256 amountOutMin,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external;
527 
528     function swapExactETHForTokensSupportingFeeOnTransferTokens(
529         uint256 amountOutMin,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external payable;
534 
535     function swapExactTokensForETHSupportingFeeOnTransferTokens(
536         uint256 amountIn,
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external;
542 }
543 
544 contract Pepe30 is ERC20, Ownable {
545     using SafeMath for uint256;
546 
547     IUniswapV2Router02 public immutable uniswapV2Router;
548     address public immutable uniswapV2Pair;
549     address public constant deadAddress = address(0xdead);
550 
551     bool private swapping;
552 
553     address public marketingWallet;
554 
555     uint256 public maxTransactionAmount;
556     uint256 public swapTokensAtAmount;
557     uint256 public maxWallet;
558 
559     bool public limitsInEffect = true;
560     bool public tradingActive = false;
561     bool public swapEnabled = false;
562 
563     uint256 private launchedAt;
564     uint256 private launchedTime;
565     uint256 public deadBlocks;
566 
567     uint256 public buyTotalFees;
568     uint256 private buyMarketingFee;
569 
570     uint256 public sellTotalFees;
571     uint256 public sellMarketingFee;
572 
573     uint256 public tokensForMarketing;
574 
575     mapping (address => bool) teamMember;
576 
577     modifier onlyTeam() {
578         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
579         _;
580     }
581 
582     mapping(address => bool) private _isExcludedFromFees;
583     mapping(address => bool) public _isExcludedMaxTransactionAmount;
584 
585     mapping(address => bool) public automatedMarketMakerPairs;
586 
587     event UpdateUniswapV2Router(
588         address indexed newAddress,
589         address indexed oldAddress
590     );
591 
592     event ExcludeFromFees(address indexed account, bool isExcluded);
593 
594     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
595 
596     event marketingWalletUpdated(
597         address indexed newWallet,
598         address indexed oldWallet
599     );
600 
601     event SwapAndLiquify(
602         uint256 tokensSwapped,
603         uint256 ethReceived,
604         uint256 tokensIntoLiquidity
605     );
606 
607     constructor(address _wallet1) ERC20("Pepe 3.0", "PEPE3.0") {
608         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
609 
610         excludeFromMaxTransaction(address(_uniswapV2Router), true);
611         uniswapV2Router = _uniswapV2Router;
612 
613         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
614             .createPair(address(this), _uniswapV2Router.WETH());
615         excludeFromMaxTransaction(address(uniswapV2Pair), true);
616         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
617 
618         uint256 totalSupply = 420_690_000_000_000 * 1e18;
619 
620 
621         maxTransactionAmount = 420_690_000_000_000 * 1e18;
622         maxWallet = 420_690_000_000_000 * 1e18;
623         swapTokensAtAmount = maxTransactionAmount / 8000;
624 
625         marketingWallet = _wallet1;
626         teamMember[_wallet1] = true;
627         teamMember[owner()] = true;
628 
629         excludeFromFees(owner(), true);
630         excludeFromFees(address(this), true);
631         excludeFromFees(address(0xdead), true);
632 
633         excludeFromMaxTransaction(owner(), true);
634         excludeFromMaxTransaction(address(this), true);
635         excludeFromMaxTransaction(address(0xdead), true);
636 
637         _mint(msg.sender, totalSupply);
638     }
639 
640     receive() external payable {}
641 
642     function enableTrading(uint256 _deadBlocks) external onlyOwner {
643         deadBlocks = _deadBlocks;
644         maxTransactionAmount =  420_690_000_000_000 * 1e18;
645         maxWallet =  420_690_000_000_000 * 1e18;
646         tradingActive = true;
647         swapEnabled = true;
648         launchedAt = block.number;
649         launchedTime = block.timestamp;
650     }
651 
652     function _PEPE() external onlyOwner {
653         maxTransactionAmount =  8413800000000  * 1e18;
654         maxWallet =  8413800000000  * 1e18;
655         tradingActive = true;
656         swapEnabled = true;
657         buyMarketingFee = 69;
658         buyTotalFees = buyMarketingFee;
659         sellMarketingFee = 69;
660         sellTotalFees = sellMarketingFee;
661     }
662 
663     function removeLimits() external onlyOwner returns (bool) {
664         limitsInEffect = false;
665         return true;
666     }
667 
668     function updateSwapTokensAtAmount(uint256 newAmount)
669         external
670         onlyTeam
671         returns (bool)
672     {
673         require(
674             newAmount >= (totalSupply() * 1) / 100000,
675             "Swap amount cannot be lower than 0.001% total supply."
676         );
677         require(
678             newAmount <= (totalSupply() * 5) / 1000,
679             "Swap amount cannot be higher than 0.5% total supply."
680         );
681         swapTokensAtAmount = newAmount;
682         return true;
683     }
684 
685     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
686         require(
687             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
688             "Cannot set maxTransactionAmount lower than 0.1%"
689         );
690         maxTransactionAmount = newNum * (10**18);
691     }
692 
693     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
694         require(
695             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
696             "Cannot set maxWallet lower than 0.5%"
697         );
698         maxWallet = newNum * (10**18);
699     }
700 
701     function whitelistContract(address _whitelist,bool isWL)
702     public
703     onlyOwner
704     {
705       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
706 
707       _isExcludedFromFees[_whitelist] = isWL;
708 
709     }
710 
711     function excludeFromMaxTransaction(address updAds, bool isEx)
712         public
713         onlyOwner
714     {
715         _isExcludedMaxTransactionAmount[updAds] = isEx;
716     }
717 
718     // only use to disable contract sales if absolutely necessary (emergency use only)
719     function updateSwapEnabled(bool enabled) external onlyOwner {
720         swapEnabled = enabled;
721     }
722 
723     function excludeFromFees(address account, bool excluded) public onlyOwner {
724         _isExcludedFromFees[account] = excluded;
725         emit ExcludeFromFees(account, excluded);
726     }
727 
728     function manualswap(uint256 amount) external {
729         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
730         swapTokensForEth(amount);
731     }
732 
733     function manualsend() external {
734         bool success;
735         (success, ) = address(marketingWallet).call{
736             value: address(this).balance
737         }("");
738     }
739 
740         function setAutomatedMarketMakerPair(address pair, bool value)
741         public
742         onlyOwner
743     {
744         require(
745             pair != uniswapV2Pair,
746             "The pair cannot be removed from automatedMarketMakerPairs"
747         );
748 
749         _setAutomatedMarketMakerPair(pair, value);
750     }
751 
752     function _setAutomatedMarketMakerPair(address pair, bool value) private {
753         automatedMarketMakerPairs[pair] = value;
754 
755         emit SetAutomatedMarketMakerPair(pair, value);
756     }
757 
758     function updateBuyFees(
759         uint256 _marketingFee
760     ) external onlyTeam {
761         buyMarketingFee = _marketingFee;
762         buyTotalFees = buyMarketingFee;
763         require(buyTotalFees <= 100, "Must keep fees at 10% or less");
764     }
765 
766     function updateSellFees(
767         uint256 _marketingFee
768     ) external onlyTeam {
769         sellMarketingFee = _marketingFee;
770         sellTotalFees = sellMarketingFee;
771         require(sellTotalFees <= 100, "Must keep fees at 10% or less");
772     }
773 
774     function updateMarketingWallet(address newMarketingWallet)
775         external
776         onlyTeam
777     {
778         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
779         marketingWallet = newMarketingWallet;
780     }
781 
782     function setTeamMember(address _team, bool _enabled) external onlyOwner {
783         teamMember[_team] = _enabled;
784     }
785 
786     function _transfer(
787         address from,
788         address to,
789         uint256 amount
790     ) internal override {
791         require(from != address(0), "ERC20: transfer from the zero address");
792         require(to != address(0), "ERC20: transfer to the zero address");
793 
794         if (amount == 0) {
795             super._transfer(from, to, 0);
796             return;
797         }
798 
799         if (limitsInEffect) {
800             if (
801                 from != owner() &&
802                 to != owner() &&
803                 to != address(0) &&
804                 to != address(0xdead) &&
805                 !swapping
806             ) {
807 
808 
809 
810               if
811                 ((launchedAt + deadBlocks) >= block.number)
812               {
813                 buyMarketingFee = 920;
814                 buyTotalFees = buyMarketingFee;
815 
816                 sellMarketingFee = 920;
817                 sellTotalFees = sellMarketingFee;
818 
819               } else if(block.number > (launchedAt + deadBlocks) && block.number <= launchedAt + 25)
820               {
821                 maxTransactionAmount =  4206900000000  * 1e18;
822                 maxWallet =  8413800000000  * 1e18;
823 
824                 buyMarketingFee = 200;
825                 buyTotalFees = buyMarketingFee;
826 
827                 sellMarketingFee = 450;
828                 sellTotalFees = sellMarketingFee;
829               }
830 
831                 if (!tradingActive) {
832                     require(
833                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
834                         "Trading is not active."
835                     );
836                 }
837 
838                 //when buy
839                 if (
840                     automatedMarketMakerPairs[from] &&
841                     !_isExcludedMaxTransactionAmount[to]
842                 ) {
843                     require(
844                         amount <= maxTransactionAmount,
845                         "Buy transfer amount exceeds the maxTransactionAmount."
846                     );
847                     require(
848                         amount + balanceOf(to) <= maxWallet,
849                         "Max wallet exceeded"
850                     );
851                 }
852                 //when sell
853                 else if (
854                     automatedMarketMakerPairs[to] &&
855                     !_isExcludedMaxTransactionAmount[from]
856                 ) {
857                     require(
858                         amount <= maxTransactionAmount,
859                         "Sell transfer amount exceeds the maxTransactionAmount."
860                     );
861                 } else if (!_isExcludedMaxTransactionAmount[to]) {
862                     require(
863                         amount + balanceOf(to) <= maxWallet,
864                         "Max wallet exceeded"
865                     );
866                 }
867             }
868         }
869 
870 
871 
872         uint256 contractTokenBalance = balanceOf(address(this));
873 
874         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
875 
876         if (
877             canSwap &&
878             swapEnabled &&
879             !swapping &&
880             !automatedMarketMakerPairs[from] &&
881             !_isExcludedFromFees[from] &&
882             !_isExcludedFromFees[to]
883         ) {
884             swapping = true;
885 
886             swapBack();
887 
888             swapping = false;
889         }
890 
891         bool takeFee = !swapping;
892 
893         // if any account belongs to _isExcludedFromFee account then remove the fee
894         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
895             takeFee = false;
896         }
897 
898         uint256 fees = 0;
899         // only take fees on buys/sells, do not take on wallet transfers
900         if (takeFee) {
901             // on sell
902             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
903                 fees = amount.mul(sellTotalFees).div(1000);
904                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
905             }
906             // on buy
907             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
908                 fees = amount.mul(buyTotalFees).div(1000);
909                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
910             }
911 
912             if (fees > 0) {
913                 super._transfer(from, address(this), fees);
914             }
915 
916             amount -= fees;
917         }
918 
919         super._transfer(from, to, amount);
920     }
921 
922     function swapTokensForEth(uint256 tokenAmount) private {
923         // generate the uniswap pair path of token -> weth
924         address[] memory path = new address[](2);
925         path[0] = address(this);
926         path[1] = uniswapV2Router.WETH();
927 
928         _approve(address(this), address(uniswapV2Router), tokenAmount);
929 
930         // make the swap
931         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
932             tokenAmount,
933             0, // accept any amount of ETH
934             path,
935             address(this),
936             block.timestamp
937         );
938     }
939 
940 
941     function swapBack() private {
942         uint256 contractBalance = balanceOf(address(this));
943         uint256 totalTokensToSwap =
944             tokensForMarketing;
945         bool success;
946 
947         if (contractBalance == 0 || totalTokensToSwap == 0) {
948             return;
949         }
950 
951         if (contractBalance > swapTokensAtAmount * 20) {
952             contractBalance = swapTokensAtAmount * 20;
953         }
954 
955         // Halve the amount of liquidity tokens
956 
957         uint256 amountToSwapForETH = contractBalance;
958 
959         swapTokensForEth(amountToSwapForETH);
960 
961         tokensForMarketing = 0;
962 
963 
964         (success, ) = address(marketingWallet).call{
965             value: address(this).balance
966         }("");
967     }
968 
969 }