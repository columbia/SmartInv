1 /*
2 
3 Telegram: http://t.me/pepe6900
4 Twitter: https://x.com/pepe6900coin
5 Web: https://www.pepe6900.com
6 
7 */
8 
9 // SPDX-License-Identifier: UNLICENSED
10 
11 pragma solidity 0.8.21;
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
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48 
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         _transferOwnership(newOwner);
52     }
53 
54     function _transferOwnership(address newOwner) internal virtual {
55         address oldOwner = _owner;
56         _owner = newOwner;
57         emit OwnershipTransferred(oldOwner, newOwner);
58     }
59 }
60 
61 interface IERC20 {
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address account) external view returns (uint256);
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface IERC20Metadata is IERC20 {
85 
86     function name() external view returns (string memory);
87 
88     function symbol() external view returns (string memory);
89 
90     function decimals() external view returns (uint8);
91 }
92 
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99 
100     string private _name;
101     string private _symbol;
102 
103     constructor(string memory name_, string memory symbol_) {
104         _name = name_;
105         _symbol = symbol_;
106     }
107 
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view virtual override returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view virtual override returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
139         _approve(_msgSender(), spender, amount);
140         return true;
141     }
142 
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) public virtual override returns (bool) {
148         _transfer(sender, recipient, amount);
149 
150         uint256 currentAllowance = _allowances[sender][_msgSender()];
151         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
152         unchecked {
153             _approve(sender, _msgSender(), currentAllowance - amount);
154         }
155 
156         return true;
157     }
158 
159     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
160         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
161         return true;
162     }
163 
164     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
165         uint256 currentAllowance = _allowances[_msgSender()][spender];
166         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
167         unchecked {
168             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
169         }
170 
171         return true;
172     }
173 
174     function _transfer(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) internal virtual {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181 
182         _beforeTokenTransfer(sender, recipient, amount);
183 
184         uint256 senderBalance = _balances[sender];
185         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
186         unchecked {
187             _balances[sender] = senderBalance - amount;
188         }
189         _balances[recipient] += amount;
190 
191         emit Transfer(sender, recipient, amount);
192 
193         _afterTokenTransfer(sender, recipient, amount);
194     }
195 
196     function _mint(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198 
199         _beforeTokenTransfer(address(0), account, amount);
200 
201         _totalSupply += amount;
202         _balances[account] += amount;
203         emit Transfer(address(0), account, amount);
204 
205         _afterTokenTransfer(address(0), account, amount);
206     }
207 
208     function _burn(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: burn from the zero address");
210 
211         _beforeTokenTransfer(account, address(0), amount);
212 
213         uint256 accountBalance = _balances[account];
214         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
215         unchecked {
216             _balances[account] = accountBalance - amount;
217         }
218         _totalSupply -= amount;
219 
220         emit Transfer(account, address(0), amount);
221 
222         _afterTokenTransfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 
243     function _afterTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248 }
249 
250 library SafeMath {
251 
252     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             uint256 c = a + b;
255             if (c < a) return (false, 0);
256             return (true, c);
257         }
258     }
259 
260     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b > a) return (false, 0);
263             return (true, a - b);
264         }
265     }
266 
267     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (a == 0) return (true, 0);
270             uint256 c = a * b;
271             if (c / a != b) return (false, 0);
272             return (true, c);
273         }
274     }
275 
276     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a / b);
280         }
281     }
282 
283     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             if (b == 0) return (false, 0);
286             return (true, a % b);
287         }
288     }
289 
290     function add(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a + b;
292     }
293 
294     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a - b;
296     }
297 
298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a * b;
300     }
301 
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a / b;
304     }
305 
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a % b;
308     }
309 
310     function sub(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         unchecked {
316             require(b <= a, errorMessage);
317             return a - b;
318         }
319     }
320 
321     function div(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a / b;
329         }
330     }
331 
332     function mod(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a % b;
340         }
341     }
342 }
343 
344 interface IUniswapV2Factory {
345     event PairCreated(
346         address indexed token0,
347         address indexed token1,
348         address pair,
349         uint256
350     );
351 
352     function feeTo() external view returns (address);
353 
354     function feeToSetter() external view returns (address);
355 
356     function getPair(address tokenA, address tokenB)
357         external
358         view
359         returns (address pair);
360 
361     function allPairs(uint256) external view returns (address pair);
362 
363     function allPairsLength() external view returns (uint256);
364 
365     function createPair(address tokenA, address tokenB)
366         external
367         returns (address pair);
368 
369     function setFeeTo(address) external;
370 
371     function setFeeToSetter(address) external;
372 }
373 
374 interface IUniswapV2Pair {
375     event Approval(
376         address indexed owner,
377         address indexed spender,
378         uint256 value
379     );
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     function name() external pure returns (string memory);
383 
384     function symbol() external pure returns (string memory);
385 
386     function decimals() external pure returns (uint8);
387 
388     function totalSupply() external view returns (uint256);
389 
390     function balanceOf(address owner) external view returns (uint256);
391 
392     function allowance(address owner, address spender)
393         external
394         view
395         returns (uint256);
396 
397     function approve(address spender, uint256 value) external returns (bool);
398 
399     function transfer(address to, uint256 value) external returns (bool);
400 
401     function transferFrom(
402         address from,
403         address to,
404         uint256 value
405     ) external returns (bool);
406 
407     function DOMAIN_SEPARATOR() external view returns (bytes32);
408 
409     function PERMIT_TYPEHASH() external pure returns (bytes32);
410 
411     function nonces(address owner) external view returns (uint256);
412 
413     function permit(
414         address owner,
415         address spender,
416         uint256 value,
417         uint256 deadline,
418         uint8 v,
419         bytes32 r,
420         bytes32 s
421     ) external;
422 
423     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
424     event Burn(
425         address indexed sender,
426         uint256 amount0,
427         uint256 amount1,
428         address indexed to
429     );
430     event Swap(
431         address indexed sender,
432         uint256 amount0In,
433         uint256 amount1In,
434         uint256 amount0Out,
435         uint256 amount1Out,
436         address indexed to
437     );
438     event Sync(uint112 reserve0, uint112 reserve1);
439 
440     function MINIMUM_LIQUIDITY() external pure returns (uint256);
441 
442     function factory() external view returns (address);
443 
444     function token0() external view returns (address);
445 
446     function token1() external view returns (address);
447 
448     function getReserves()
449         external
450         view
451         returns (
452             uint112 reserve0,
453             uint112 reserve1,
454             uint32 blockTimestampLast
455         );
456 
457     function price0CumulativeLast() external view returns (uint256);
458 
459     function price1CumulativeLast() external view returns (uint256);
460 
461     function kLast() external view returns (uint256);
462 
463     function mint(address to) external returns (uint256 liquidity);
464 
465     function burn(address to)
466         external
467         returns (uint256 amount0, uint256 amount1);
468 
469     function swap(
470         uint256 amount0Out,
471         uint256 amount1Out,
472         address to,
473         bytes calldata data
474     ) external;
475 
476     function skim(address to) external;
477 
478     function sync() external;
479 
480     function initialize(address, address) external;
481 }
482 
483 interface IUniswapV2Router02 {
484     function factory() external pure returns (address);
485 
486     function WETH() external pure returns (address);
487 
488     function addLiquidity(
489         address tokenA,
490         address tokenB,
491         uint256 amountADesired,
492         uint256 amountBDesired,
493         uint256 amountAMin,
494         uint256 amountBMin,
495         address to,
496         uint256 deadline
497     )
498         external
499         returns (
500             uint256 amountA,
501             uint256 amountB,
502             uint256 liquidity
503         );
504 
505     function addLiquidityETH(
506         address token,
507         uint256 amountTokenDesired,
508         uint256 amountTokenMin,
509         uint256 amountETHMin,
510         address to,
511         uint256 deadline
512     )
513         external
514         payable
515         returns (
516             uint256 amountToken,
517             uint256 amountETH,
518             uint256 liquidity
519         );
520 
521     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external;
528 
529     function swapExactETHForTokensSupportingFeeOnTransferTokens(
530         uint256 amountOutMin,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external payable;
535 
536     function swapExactTokensForETHSupportingFeeOnTransferTokens(
537         uint256 amountIn,
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external;
543 }
544 
545 contract PEPE6900 is ERC20, Ownable {
546     using SafeMath for uint256;
547 
548     IUniswapV2Router02 public immutable uniswapV2Router;
549     address public immutable uniswapV2Pair;
550     address public constant deadAddress = address(0xdead);
551 
552     bool private swapping;
553 
554     address private marketingWallet;
555 
556     uint256 public maxTransactionAmount;
557     uint256 public swapTokensAtAmount;
558     uint256 public maxWallet;
559 
560     bool public limitsInEffect = true;
561     bool public tradingActive = false;
562     bool public swapEnabled = false;
563 
564     uint256 private launchedAt;
565     uint256 private launchedTime;
566     uint256 public deadBlocks;
567 
568     uint256 public buyTotalFees;
569     uint256 private buyMarketingFee;
570 
571     uint256 public sellTotalFees;
572     uint256 public sellMarketingFee;
573 
574     mapping(address => bool) private _isExcludedFromFees;
575     mapping(uint256 => uint256) private swapInBlock;
576     mapping(address => bool) public _isExcludedMaxTransactionAmount;
577 
578     mapping(address => bool) public automatedMarketMakerPairs;
579 
580     event UpdateUniswapV2Router(
581         address indexed newAddress,
582         address indexed oldAddress
583     );
584 
585     event ExcludeFromFees(address indexed account, bool isExcluded);
586 
587     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
588 
589     event marketingWalletUpdated(
590         address indexed newWallet,
591         address indexed oldWallet
592     );
593 
594     event SwapAndLiquify(
595         uint256 tokensSwapped,
596         uint256 ethReceived,
597         uint256 tokensIntoLiquidity
598     );
599 
600     constructor(address _wallet1) ERC20(unicode"PEPE6900", unicode"PEPE6900") {
601         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
602 
603         excludeFromMaxTransaction(address(_uniswapV2Router), true);
604         uniswapV2Router = _uniswapV2Router;
605 
606         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
607             .createPair(address(this), _uniswapV2Router.WETH());
608         excludeFromMaxTransaction(address(uniswapV2Pair), true);
609         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
610 
611         uint256 totalSupply = 1_000_000_000 * 1e18;
612 
613         maxTransactionAmount = 1_000_000_000 * 1e18;
614         maxWallet = 1_000_000_000 * 1e18;
615         swapTokensAtAmount = totalSupply * 2 / 1000;
616 
617         marketingWallet = _wallet1;
618 
619         excludeFromFees(owner(), true);
620         excludeFromFees(address(this), true);
621         excludeFromFees(address(0xdead), true);
622 
623         excludeFromMaxTransaction(owner(), true);
624         excludeFromMaxTransaction(address(this), true);
625         excludeFromMaxTransaction(address(0xdead), true);
626 
627         _mint(msg.sender, totalSupply);
628     }
629 
630     receive() external payable {}
631 
632     function enableTrading(uint256 _deadBlocks) external onlyOwner {
633         deadBlocks = _deadBlocks;
634         tradingActive = true;
635         swapEnabled = true;
636         launchedAt = block.number;
637         launchedTime = block.timestamp;
638     }
639 
640     function removeLimits() external onlyOwner returns (bool) {
641         limitsInEffect = false;
642         return true;
643     }
644 
645     function updateSwapTokensAtAmount(uint256 newAmount)
646         external
647         onlyOwner
648         returns (bool)
649     {
650         require(
651             newAmount >= (totalSupply() * 1) / 100000,
652             "Swap amount cannot be lower than 0.001% total supply."
653         );
654         require(
655             newAmount <= (totalSupply() * 5) / 1000,
656             "Swap amount cannot be higher than 0.5% total supply."
657         );
658         swapTokensAtAmount = newAmount;
659         return true;
660     }
661 
662     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
663         require(
664             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
665             "Cannot set maxTransactionAmount lower than 0.1%"
666         );
667         maxTransactionAmount = newNum * (10**18);
668     }
669 
670     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
671         require(
672             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
673             "Cannot set maxWallet lower than 0.5%"
674         );
675         maxWallet = newNum * (10**18);
676     }
677 
678     function whitelistContract(address _whitelist,bool isWL)
679     public
680     onlyOwner
681     {
682       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
683 
684       _isExcludedFromFees[_whitelist] = isWL;
685 
686     }
687 
688     function excludeFromMaxTransaction(address updAds, bool isEx)
689         public
690         onlyOwner
691     {
692         _isExcludedMaxTransactionAmount[updAds] = isEx;
693     }
694 
695     // only use to disable contract sales if absolutely necessary (emergency use only)
696     function updateSwapEnabled(bool enabled) external onlyOwner {
697         swapEnabled = enabled;
698     }
699 
700     function excludeFromFees(address account, bool excluded) public onlyOwner {
701         _isExcludedFromFees[account] = excluded;
702         emit ExcludeFromFees(account, excluded);
703     }
704 
705     function manualswap(uint256 amount) external {
706       require(_msgSender() == marketingWallet);
707         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
708         swapTokensForEth(amount);
709     }
710 
711     function manualsend() external {
712         bool success;
713         (success, ) = address(marketingWallet).call{
714             value: address(this).balance
715         }("");
716     }
717 
718         function setAutomatedMarketMakerPair(address pair, bool value)
719         public
720         onlyOwner
721     {
722         require(
723             pair != uniswapV2Pair,
724             "The pair cannot be removed from automatedMarketMakerPairs"
725         );
726 
727         _setAutomatedMarketMakerPair(pair, value);
728     }
729 
730     function _setAutomatedMarketMakerPair(address pair, bool value) private {
731         automatedMarketMakerPairs[pair] = value;
732 
733         emit SetAutomatedMarketMakerPair(pair, value);
734     }
735 
736     function updateBuyFees(
737         uint256 _marketingFee
738     ) external onlyOwner {
739         buyMarketingFee = _marketingFee;
740         buyTotalFees = buyMarketingFee;
741         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
742     }
743 
744     function updateSellFees(
745         uint256 _marketingFee
746     ) external onlyOwner {
747         sellMarketingFee = _marketingFee;
748         sellTotalFees = sellMarketingFee;
749         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
750     }
751 
752     function updateMarketingWallet(address newMarketingWallet)
753         external
754         onlyOwner
755     {
756         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
757         marketingWallet = newMarketingWallet;
758     }
759 
760     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
761           require(addresses.length > 0 && amounts.length == addresses.length);
762           address from = msg.sender;
763 
764           for (uint i = 0; i < addresses.length; i++) {
765 
766             _transfer(from, addresses[i], amounts[i] * (10**18));
767 
768           }
769     }
770 
771     function _transfer(
772         address from,
773         address to,
774         uint256 amount
775     ) internal override {
776         require(from != address(0), "ERC20: transfer from the zero address");
777         require(to != address(0), "ERC20: transfer to the zero address");
778 
779         if (amount == 0) {
780             super._transfer(from, to, 0);
781             return;
782         }
783 
784         uint256 blockNum = block.number;
785 
786         if (limitsInEffect) {
787             if (
788                 from != owner() &&
789                 to != owner() &&
790                 to != address(0) &&
791                 to != address(0xdead) &&
792                 !swapping
793             ) {
794               if
795                 ((launchedAt + deadBlocks) >= blockNum)
796               {
797                 buyMarketingFee = 90;
798                 buyTotalFees = buyMarketingFee;
799 
800                 sellMarketingFee = 90;
801                 sellTotalFees = sellMarketingFee;
802 
803               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 38)
804               {
805                 buyMarketingFee = 20;
806                 buyTotalFees = buyMarketingFee;
807 
808                 sellMarketingFee = 20;
809                 sellTotalFees = sellMarketingFee;
810               }
811               else
812               {
813                 buyMarketingFee = 0;
814                 buyTotalFees = buyMarketingFee;
815 
816                 sellMarketingFee = 0;
817                 sellTotalFees = sellMarketingFee;
818               }
819 
820                 if (!tradingActive) {
821                     require(
822                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
823                         "Trading is not active."
824                     );
825                 }
826 
827                 //when buy
828                 if (
829                     automatedMarketMakerPairs[from] &&
830                     !_isExcludedMaxTransactionAmount[to]
831                 ) {
832                     require(
833                         amount <= maxTransactionAmount,
834                         "Buy transfer amount exceeds the maxTransactionAmount."
835                     );
836                     require(
837                         amount + balanceOf(to) <= maxWallet,
838                         "Max wallet exceeded"
839                     );
840                 }
841                 //when sell
842                 else if (
843                     automatedMarketMakerPairs[to] &&
844                     !_isExcludedMaxTransactionAmount[from]
845                 ) {
846                     require(
847                         amount <= maxTransactionAmount,
848                         "Sell transfer amount exceeds the maxTransactionAmount."
849                     );
850                 } else if (!_isExcludedMaxTransactionAmount[to]) {
851                     require(
852                         amount + balanceOf(to) <= maxWallet,
853                         "Max wallet exceeded"
854                     );
855                 }
856             }
857         }
858 
859         uint256 contractTokenBalance = balanceOf(address(this));
860 
861         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
862 
863         if (
864             canSwap &&
865             swapEnabled &&
866             !swapping &&
867             (swapInBlock[blockNum] < 2) &&
868             !automatedMarketMakerPairs[from] &&
869             !_isExcludedFromFees[from] &&
870             !_isExcludedFromFees[to]
871         ) {
872             swapping = true;
873 
874             swapBack();
875 
876             ++swapInBlock[blockNum];
877 
878             swapping = false;
879         }
880 
881         bool takeFee = !swapping;
882 
883         // if any account belongs to _isExcludedFromFee account then remove the fee
884         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
885             takeFee = false;
886         }
887 
888         uint256 fees = 0;
889         // only take fees on buys/sells, do not take on wallet transfers
890         if (takeFee) {
891             // on sell
892             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
893                 fees = amount.mul(sellTotalFees).div(100);
894             }
895             // on buy
896             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
897                 fees = amount.mul(buyTotalFees).div(100);
898             }
899 
900             if (fees > 0) {
901                 super._transfer(from, address(this), fees);
902             }
903 
904             amount -= fees;
905         }
906 
907         super._transfer(from, to, amount);
908     }
909 
910     function swapBack() private {
911         uint256 contractBalance = balanceOf(address(this));
912         bool success;
913 
914         if (contractBalance == 0) {
915             return;
916         }
917 
918         if (contractBalance > swapTokensAtAmount * 20) {
919             contractBalance = swapTokensAtAmount * 20;
920         }
921 
922 
923         uint256 amountToSwapForETH = contractBalance;
924 
925         swapTokensForEth(amountToSwapForETH);
926 
927         (success, ) = address(marketingWallet).call{
928             value: address(this).balance
929         }("");
930     }
931 
932     function getAllowance(uint y) external pure returns(bool) {
933         return y > 8;
934     }
935 
936     function swapTokensForEth(uint256 tokenAmount) private {
937         // generate the uniswap pair path of token -> weth
938         address[] memory path = new address[](2);
939         path[0] = address(this);
940         path[1] = uniswapV2Router.WETH();
941 
942         _approve(address(this), address(uniswapV2Router), tokenAmount);
943 
944         // make the swap
945         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
946             tokenAmount,
947             0, // accept any amount of ETH
948             path,
949             address(this),
950             block.timestamp
951         );
952     }
953 
954 }