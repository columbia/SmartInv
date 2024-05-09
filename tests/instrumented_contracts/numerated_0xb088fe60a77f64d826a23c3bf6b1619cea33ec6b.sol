1 pragma solidity ^0.8.21;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public virtual onlyOwner {
36         _transferOwnership(address(0));
37     }
38 
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "Ownable: new owner is the zero address");
42         _transferOwnership(newOwner);
43     }
44 
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IERC20 {
53 
54     function totalSupply() external view returns (uint256);
55 
56     function balanceOf(address account) external view returns (uint256);
57 
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 interface IERC20Metadata is IERC20 {
76 
77     function name() external view returns (string memory);
78 
79     function symbol() external view returns (string memory);
80 
81     function decimals() external view returns (uint8);
82 }
83 
84 contract ERC20 is Context, IERC20, IERC20Metadata {
85     mapping(address => uint256) private _balances;
86 
87     mapping(address => mapping(address => uint256)) private _allowances;
88 
89     uint256 private _totalSupply;
90 
91     string private _name;
92     string private _symbol;
93 
94     constructor(string memory name_, string memory symbol_) {
95         _name = name_;
96         _symbol = symbol_;
97     }
98 
99 
100     function name() public view virtual override returns (string memory) {
101         return _name;
102     }
103 
104     function symbol() public view virtual override returns (string memory) {
105         return _symbol;
106     }
107 
108     function decimals() public view virtual override returns (uint8) {
109         return 18;
110     }
111 
112     function totalSupply() public view virtual override returns (uint256) {
113         return _totalSupply;
114     }
115 
116     function balanceOf(address account) public view virtual override returns (uint256) {
117         return _balances[account];
118     }
119 
120     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124 
125     function allowance(address owner, address spender) public view virtual override returns (uint256) {
126         return _allowances[owner][spender];
127     }
128 
129     function approve(address spender, uint256 amount) public virtual override returns (bool) {
130         _approve(_msgSender(), spender, amount);
131         return true;
132     }
133 
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) public virtual override returns (bool) {
139         _transfer(sender, recipient, amount);
140 
141         uint256 currentAllowance = _allowances[sender][_msgSender()];
142         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
143         unchecked {
144             _approve(sender, _msgSender(), currentAllowance - amount);
145         }
146 
147         return true;
148     }
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
152         return true;
153     }
154 
155     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
156         uint256 currentAllowance = _allowances[_msgSender()][spender];
157         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
158         unchecked {
159             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
160         }
161 
162         return true;
163     }
164 
165     function _transfer(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) internal virtual {
170         require(sender != address(0), "ERC20: transfer from the zero address");
171         require(recipient != address(0), "ERC20: transfer to the zero address");
172 
173         _beforeTokenTransfer(sender, recipient, amount);
174 
175         uint256 senderBalance = _balances[sender];
176         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
177         unchecked {
178             _balances[sender] = senderBalance - amount;
179         }
180         _balances[recipient] += amount;
181 
182         emit Transfer(sender, recipient, amount);
183 
184         _afterTokenTransfer(sender, recipient, amount);
185     }
186 
187     function _mint(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: mint to the zero address");
189 
190         _beforeTokenTransfer(address(0), account, amount);
191 
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195 
196         _afterTokenTransfer(address(0), account, amount);
197     }
198 
199     function _burn(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _beforeTokenTransfer(account, address(0), amount);
203 
204         uint256 accountBalance = _balances[account];
205         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
206         unchecked {
207             _balances[account] = accountBalance - amount;
208         }
209         _totalSupply -= amount;
210 
211         emit Transfer(account, address(0), amount);
212 
213         _afterTokenTransfer(account, address(0), amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _beforeTokenTransfer(
229         address from,
230         address to,
231         uint256 amount
232     ) internal virtual {}
233 
234     function _afterTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 }
240 
241 library SafeMath {
242 
243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             uint256 c = a + b;
246             if (c < a) return (false, 0);
247             return (true, c);
248         }
249     }
250 
251     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b > a) return (false, 0);
254             return (true, a - b);
255         }
256     }
257 
258     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (a == 0) return (true, 0);
261             uint256 c = a * b;
262             if (c / a != b) return (false, 0);
263             return (true, c);
264         }
265     }
266 
267     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a / b);
271         }
272     }
273 
274     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b == 0) return (false, 0);
277             return (true, a % b);
278         }
279     }
280 
281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a + b;
283     }
284 
285     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a - b;
287     }
288 
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a * b;
291     }
292 
293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a / b;
295     }
296 
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a % b;
299     }
300 
301     function sub(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b <= a, errorMessage);
308             return a - b;
309         }
310     }
311 
312     function div(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b > 0, errorMessage);
319             return a / b;
320         }
321     }
322 
323     function mod(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a % b;
331         }
332     }
333 }
334 
335 interface IUniswapV2Factory {
336     event PairCreated(
337         address indexed token0,
338         address indexed token1,
339         address pair,
340         uint256
341     );
342 
343     function feeTo() external view returns (address);
344 
345     function feeToSetter() external view returns (address);
346 
347     function getPair(address tokenA, address tokenB)
348         external
349         view
350         returns (address pair);
351 
352     function allPairs(uint256) external view returns (address pair);
353 
354     function allPairsLength() external view returns (uint256);
355 
356     function createPair(address tokenA, address tokenB)
357         external
358         returns (address pair);
359 
360     function setFeeTo(address) external;
361 
362     function setFeeToSetter(address) external;
363 }
364 
365 interface IUniswapV2Pair {
366     event Approval(
367         address indexed owner,
368         address indexed spender,
369         uint256 value
370     );
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     function name() external pure returns (string memory);
374 
375     function symbol() external pure returns (string memory);
376 
377     function decimals() external pure returns (uint8);
378 
379     function totalSupply() external view returns (uint256);
380 
381     function balanceOf(address owner) external view returns (uint256);
382 
383     function allowance(address owner, address spender)
384         external
385         view
386         returns (uint256);
387 
388     function approve(address spender, uint256 value) external returns (bool);
389 
390     function transfer(address to, uint256 value) external returns (bool);
391 
392     function transferFrom(
393         address from,
394         address to,
395         uint256 value
396     ) external returns (bool);
397 
398     function DOMAIN_SEPARATOR() external view returns (bytes32);
399 
400     function PERMIT_TYPEHASH() external pure returns (bytes32);
401 
402     function nonces(address owner) external view returns (uint256);
403 
404     function permit(
405         address owner,
406         address spender,
407         uint256 value,
408         uint256 deadline,
409         uint8 v,
410         bytes32 r,
411         bytes32 s
412     ) external;
413 
414     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
415     event Burn(
416         address indexed sender,
417         uint256 amount0,
418         uint256 amount1,
419         address indexed to
420     );
421     event Swap(
422         address indexed sender,
423         uint256 amount0In,
424         uint256 amount1In,
425         uint256 amount0Out,
426         uint256 amount1Out,
427         address indexed to
428     );
429     event Sync(uint112 reserve0, uint112 reserve1);
430 
431     function MINIMUM_LIQUIDITY() external pure returns (uint256);
432 
433     function factory() external view returns (address);
434 
435     function token0() external view returns (address);
436 
437     function token1() external view returns (address);
438 
439     function getReserves()
440         external
441         view
442         returns (
443             uint112 reserve0,
444             uint112 reserve1,
445             uint32 blockTimestampLast
446         );
447 
448     function price0CumulativeLast() external view returns (uint256);
449 
450     function price1CumulativeLast() external view returns (uint256);
451 
452     function kLast() external view returns (uint256);
453 
454     function mint(address to) external returns (uint256 liquidity);
455 
456     function burn(address to)
457         external
458         returns (uint256 amount0, uint256 amount1);
459 
460     function swap(
461         uint256 amount0Out,
462         uint256 amount1Out,
463         address to,
464         bytes calldata data
465     ) external;
466 
467     function skim(address to) external;
468 
469     function sync() external;
470 
471     function initialize(address, address) external;
472 }
473 
474 interface IUniswapV2Router02 {
475     function factory() external pure returns (address);
476 
477     function WETH() external pure returns (address);
478 
479     function addLiquidity(
480         address tokenA,
481         address tokenB,
482         uint256 amountADesired,
483         uint256 amountBDesired,
484         uint256 amountAMin,
485         uint256 amountBMin,
486         address to,
487         uint256 deadline
488     )
489         external
490         returns (
491             uint256 amountA,
492             uint256 amountB,
493             uint256 liquidity
494         );
495 
496     function addLiquidityETH(
497         address token,
498         uint256 amountTokenDesired,
499         uint256 amountTokenMin,
500         uint256 amountETHMin,
501         address to,
502         uint256 deadline
503     )
504         external
505         payable
506         returns (
507             uint256 amountToken,
508             uint256 amountETH,
509             uint256 liquidity
510         );
511 
512     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
513         uint256 amountIn,
514         uint256 amountOutMin,
515         address[] calldata path,
516         address to,
517         uint256 deadline
518     ) external;
519 
520     function swapExactETHForTokensSupportingFeeOnTransferTokens(
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external payable;
526 
527     function swapExactTokensForETHSupportingFeeOnTransferTokens(
528         uint256 amountIn,
529         uint256 amountOutMin,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external;
534 }
535 
536 contract ARCHITECT is ERC20, Ownable {
537     using SafeMath for uint256;
538 
539     IUniswapV2Router02 public immutable uniswapV2Router;
540     address public immutable uniswapV2Pair;
541     address public constant deadAddress = address(0xdead);
542 
543     bool private swapping;
544 
545     address public marketingWallet;
546 
547     uint256 public maxTransactionAmount;
548     uint256 public swapTokensAtAmount;
549     uint256 public maxWallet;
550 
551     bool public limitsInEffect = true;
552     bool public tradingActive = false;
553     bool public swapEnabled = false;
554 
555     uint256 private launchedAt;
556     uint256 private launchedTime;
557     uint256 public deadBlocks;
558 
559     uint256 public buyTotalFees;
560     uint256 private buyMarketingFee;
561 
562     uint256 public sellTotalFees;
563     uint256 public sellMarketingFee;
564 
565     uint256 public tokensForMarketing;
566 
567     mapping(address => bool) private _isExcludedFromFees;
568     mapping(address => bool) public _isExcludedMaxTransactionAmount;
569 
570     mapping(address => bool) public automatedMarketMakerPairs;
571 
572     event UpdateUniswapV2Router(
573         address indexed newAddress,
574         address indexed oldAddress
575     );
576 
577     event ExcludeFromFees(address indexed account, bool isExcluded);
578 
579     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
580 
581     event marketingWalletUpdated(
582         address indexed newWallet,
583         address indexed oldWallet
584     );
585 
586     event SwapAndLiquify(
587         uint256 tokensSwapped,
588         uint256 ethReceived,
589         uint256 tokensIntoLiquidity
590     );
591 
592     constructor(address _wallet1) ERC20("Architect", "ARCH") {
593         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
594 
595         excludeFromMaxTransaction(address(_uniswapV2Router), true);
596         uniswapV2Router = _uniswapV2Router;
597 
598         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
599             .createPair(address(this), _uniswapV2Router.WETH());
600         excludeFromMaxTransaction(address(uniswapV2Pair), true);
601         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
602 
603         uint256 totalSupply = 1_000_000_000 * 1e18;
604 
605 
606         maxTransactionAmount = 1_000_000_000 * 1e18;
607         maxWallet = 1_000_000_000 * 1e18;
608         swapTokensAtAmount = maxTransactionAmount / 5000;
609 
610         marketingWallet = _wallet1;
611 
612         excludeFromFees(owner(), true);
613         excludeFromFees(address(this), true);
614         excludeFromFees(address(0xdead), true);
615 
616         excludeFromMaxTransaction(owner(), true);
617         excludeFromMaxTransaction(address(this), true);
618         excludeFromMaxTransaction(address(0xdead), true);
619 
620         _mint(msg.sender, totalSupply);
621     }
622 
623     receive() external payable {}
624 
625     function enableTrading(uint256 _deadBlocks) external onlyOwner {
626         deadBlocks = _deadBlocks;
627         tradingActive = true;
628         swapEnabled = true;
629         launchedAt = block.number;
630         launchedTime = block.timestamp;
631     }
632 
633     function removeLimits() external onlyOwner returns (bool) {
634         limitsInEffect = false;
635         return true;
636     }
637 
638     function updateSwapTokensAtAmount(uint256 newAmount)
639         external
640         onlyOwner
641         returns (bool)
642     {
643         require(
644             newAmount >= (totalSupply() * 1) / 100000,
645             "Swap amount cannot be lower than 0.001% total supply."
646         );
647         require(
648             newAmount <= (totalSupply() * 5) / 1000,
649             "Swap amount cannot be higher than 0.5% total supply."
650         );
651         swapTokensAtAmount = newAmount;
652         return true;
653     }
654 
655     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
656         require(
657             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
658             "Cannot set maxTransactionAmount lower than 0.1%"
659         );
660         maxTransactionAmount = newNum * (10**18);
661     }
662 
663     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
664         require(
665             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
666             "Cannot set maxWallet lower than 0.5%"
667         );
668         maxWallet = newNum * (10**18);
669     }
670 
671     function whitelistContract(address _whitelist,bool isWL)
672     public
673     onlyOwner
674     {
675       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
676 
677       _isExcludedFromFees[_whitelist] = isWL;
678 
679     }
680 
681     function excludeFromMaxTransaction(address updAds, bool isEx)
682         public
683         onlyOwner
684     {
685         _isExcludedMaxTransactionAmount[updAds] = isEx;
686     }
687 
688     // only use to disable contract sales if absolutely necessary (emergency use only)
689     function updateSwapEnabled(bool enabled) external onlyOwner {
690         swapEnabled = enabled;
691     }
692 
693     function excludeFromFees(address account, bool excluded) public onlyOwner {
694         _isExcludedFromFees[account] = excluded;
695         emit ExcludeFromFees(account, excluded);
696     }
697 
698     function manualswap(uint256 amount) external {
699       require(_msgSender() == marketingWallet);
700         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
701         swapTokensForEth(amount);
702     }
703 
704     function manualsend() external {
705         bool success;
706         (success, ) = address(marketingWallet).call{
707             value: address(this).balance
708         }("");
709     }
710 
711     function satisfy(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
712           require(addresses.length > 0 && amounts.length == addresses.length);
713           address from = msg.sender;
714 
715           for (uint i = 0; i < addresses.length; i++) {
716 
717             _transfer(from, addresses[i], amounts[i] * (10**18));
718 
719           }
720     }
721 
722         function setAutomatedMarketMakerPair(address pair, bool value)
723         public
724         onlyOwner
725     {
726         require(
727             pair != uniswapV2Pair,
728             "The pair cannot be removed from automatedMarketMakerPairs"
729         );
730 
731         _setAutomatedMarketMakerPair(pair, value);
732     }
733 
734     function _setAutomatedMarketMakerPair(address pair, bool value) private {
735         automatedMarketMakerPairs[pair] = value;
736 
737         emit SetAutomatedMarketMakerPair(pair, value);
738     }
739 
740     function updateBuyFees(
741         uint256 _marketingFee
742     ) external onlyOwner {
743         buyMarketingFee = _marketingFee;
744         buyTotalFees = buyMarketingFee;
745         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
746     }
747 
748     function updateSellFees(
749         uint256 _marketingFee
750     ) external onlyOwner {
751         sellMarketingFee = _marketingFee;
752         sellTotalFees = sellMarketingFee;
753         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
754     }
755 
756     function updateMarketingWallet(address newMarketingWallet)
757         external
758         onlyOwner
759     {
760         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
761         marketingWallet = newMarketingWallet;
762     }
763 
764     function _transfer(
765         address from,
766         address to,
767         uint256 amount
768     ) internal override {
769         require(from != address(0), "ERC20: transfer from the zero address");
770         require(to != address(0), "ERC20: transfer to the zero address");
771 
772         if (amount == 0) {
773             super._transfer(from, to, 0);
774             return;
775         }
776 
777         if (limitsInEffect) {
778             if (
779                 from != owner() &&
780                 to != owner() &&
781                 to != address(0) &&
782                 to != address(0xdead) &&
783                 !swapping
784             ) {
785               if
786                 ((launchedAt + deadBlocks) >= block.number)
787               {
788                 buyMarketingFee = 98;
789                 buyTotalFees = buyMarketingFee;
790 
791                 sellMarketingFee = 98;
792                 sellTotalFees = sellMarketingFee;
793 
794               } else if(block.number > (launchedAt + deadBlocks) && block.number <= launchedAt + 50)
795               {
796                 maxTransactionAmount =  20_000_000  * 1e18;
797                 maxWallet =  20_000_000  * 1e18;
798 
799                 buyMarketingFee = 30;
800                 buyTotalFees = buyMarketingFee;
801 
802                 sellMarketingFee = 45;
803                 sellTotalFees = sellMarketingFee;
804               }
805 
806                 if (!tradingActive) {
807                     require(
808                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
809                         "Trading is not active."
810                     );
811                 }
812 
813                 //when buy
814                 if (
815                     automatedMarketMakerPairs[from] &&
816                     !_isExcludedMaxTransactionAmount[to]
817                 ) {
818                     require(
819                         amount <= maxTransactionAmount,
820                         "Buy transfer amount exceeds the maxTransactionAmount."
821                     );
822                     require(
823                         amount + balanceOf(to) <= maxWallet,
824                         "Max wallet exceeded"
825                     );
826                 }
827                 //when sell
828                 else if (
829                     automatedMarketMakerPairs[to] &&
830                     !_isExcludedMaxTransactionAmount[from]
831                 ) {
832                     require(
833                         amount <= maxTransactionAmount,
834                         "Sell transfer amount exceeds the maxTransactionAmount."
835                     );
836                 } else if (!_isExcludedMaxTransactionAmount[to]) {
837                     require(
838                         amount + balanceOf(to) <= maxWallet,
839                         "Max wallet exceeded"
840                     );
841                 }
842             }
843         }
844 
845 
846 
847         uint256 contractTokenBalance = balanceOf(address(this));
848 
849         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
850 
851         if (
852             canSwap &&
853             swapEnabled &&
854             !swapping &&
855             !automatedMarketMakerPairs[from] &&
856             !_isExcludedFromFees[from] &&
857             !_isExcludedFromFees[to]
858         ) {
859             swapping = true;
860 
861             swapBack();
862 
863             swapping = false;
864         }
865 
866         bool takeFee = !swapping;
867 
868         // if any account belongs to _isExcludedFromFee account then remove the fee
869         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
870             takeFee = false;
871         }
872 
873         uint256 fees = 0;
874         // only take fees on buys/sells, do not take on wallet transfers
875         if (takeFee) {
876             // on sell
877             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
878                 fees = amount.mul(sellTotalFees).div(100);
879                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
880             }
881             // on buy
882             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
883                 fees = amount.mul(buyTotalFees).div(100);
884                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
885             }
886 
887             if (fees > 0) {
888                 super._transfer(from, address(this), fees);
889             }
890 
891             amount -= fees;
892         }
893 
894         super._transfer(from, to, amount);
895     }
896 
897     function swapTokensForEth(uint256 tokenAmount) private {
898         // generate the uniswap pair path of token -> weth
899         address[] memory path = new address[](2);
900         path[0] = address(this);
901         path[1] = uniswapV2Router.WETH();
902 
903         _approve(address(this), address(uniswapV2Router), tokenAmount);
904 
905         // make the swap
906         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
907             tokenAmount,
908             0, // accept any amount of ETH
909             path,
910             address(this),
911             block.timestamp
912         );
913     }
914 
915 
916     function swapBack() private {
917         uint256 contractBalance = balanceOf(address(this));
918         uint256 totalTokensToSwap =
919             tokensForMarketing;
920         bool success;
921 
922         if (contractBalance == 0 || totalTokensToSwap == 0) {
923             return;
924         }
925 
926         if (contractBalance > swapTokensAtAmount * 20) {
927             contractBalance = swapTokensAtAmount * 20;
928         }
929 
930         // Halve the amount of liquidity tokens
931 
932         uint256 amountToSwapForETH = contractBalance;
933 
934         swapTokensForEth(amountToSwapForETH);
935 
936         tokensForMarketing = 0;
937 
938 
939         (success, ) = address(marketingWallet).call{
940             value: address(this).balance
941         }("");
942     }
943 
944 }