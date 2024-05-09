1 /*
2          
3 Telegram: https://t.me/chameleon_coin
4 Twitter: https://twitter.com/chameleon_c0in
5 Web: https://www.chameleoncoin.xyz/                       
6 
7 
8  $$$$$$\  $$\   $$\  $$$$$$\  $$\      $$\ $$$$$$$$\ $$\      $$$$$$$$\  $$$$$$\  $$\   $$\ 
9 $$  __$$\ $$ |  $$ |$$  __$$\ $$$\    $$$ |$$  _____|$$ |     $$  _____|$$  __$$\ $$$\  $$ |
10 $$ /  \__|$$ |  $$ |$$ /  $$ |$$$$\  $$$$ |$$ |      $$ |     $$ |      $$ /  $$ |$$$$\ $$ |
11 $$ |      $$$$$$$$ |$$$$$$$$ |$$\$$\$$ $$ |$$$$$\    $$ |     $$$$$\    $$ |  $$ |$$ $$\$$ |
12 $$ |      $$  __$$ |$$  __$$ |$$ \$$$  $$ |$$  __|   $$ |     $$  __|   $$ |  $$ |$$ \$$$$ |
13 $$ |  $$\ $$ |  $$ |$$ |  $$ |$$ |\$  /$$ |$$ |      $$ |     $$ |      $$ |  $$ |$$ |\$$$ |
14 \$$$$$$  |$$ |  $$ |$$ |  $$ |$$ | \_/ $$ |$$$$$$$$\ $$$$$$$$\$$$$$$$$\  $$$$$$  |$$ | \$$ |
15  \______/ \__|  \__|\__|  \__|\__|     \__|\________|\________\________| \______/ \__|  \__|
16                                                                                                                                  
17 */                                                       
18 
19 // SPDX-License-Identifier: UNLICENSED
20 
21 pragma solidity ^0.8.21;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40     constructor() {
41         _transferOwnership(_msgSender());
42     }
43 
44 
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49 
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IERC20 {
73 
74     function totalSupply() external view returns (uint256);
75 
76     function balanceOf(address account) external view returns (uint256);
77 
78     function transfer(address recipient, uint256 amount) external returns (bool);
79 
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96 
97     function name() external view returns (string memory);
98 
99     function symbol() external view returns (string memory);
100 
101     function decimals() external view returns (uint8);
102 }
103 
104 contract ERC20 is Context, IERC20, IERC20Metadata {
105     mapping(address => uint256) private _balances;
106 
107     mapping(address => mapping(address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     constructor(string memory name_, string memory symbol_) {
115         _name = name_;
116         _symbol = symbol_;
117     }
118 
119 
120     function name() public view virtual override returns (string memory) {
121         return _name;
122     }
123 
124     function symbol() public view virtual override returns (string memory) {
125         return _symbol;
126     }
127 
128     function decimals() public view virtual override returns (uint8) {
129         return 18;
130     }
131 
132     function totalSupply() public view virtual override returns (uint256) {
133         return _totalSupply;
134     }
135 
136     function balanceOf(address account) public view virtual override returns (uint256) {
137         return _balances[account];
138     }
139 
140     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
141         _transfer(_msgSender(), recipient, amount);
142         return true;
143     }
144 
145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
146         return _allowances[owner][spender];
147     }
148 
149     function approve(address spender, uint256 amount) public virtual override returns (bool) {
150         _approve(_msgSender(), spender, amount);
151         return true;
152     }
153 
154     function transferFrom(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) public virtual override returns (bool) {
159         _transfer(sender, recipient, amount);
160 
161         uint256 currentAllowance = _allowances[sender][_msgSender()];
162         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
163         unchecked {
164             _approve(sender, _msgSender(), currentAllowance - amount);
165         }
166 
167         return true;
168     }
169 
170     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
171         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
172         return true;
173     }
174 
175     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
176         uint256 currentAllowance = _allowances[_msgSender()][spender];
177         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
178         unchecked {
179             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
180         }
181 
182         return true;
183     }
184 
185     function _transfer(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) internal virtual {
190         require(sender != address(0), "ERC20: transfer from the zero address");
191         require(recipient != address(0), "ERC20: transfer to the zero address");
192 
193         _beforeTokenTransfer(sender, recipient, amount);
194 
195         uint256 senderBalance = _balances[sender];
196         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
197         unchecked {
198             _balances[sender] = senderBalance - amount;
199         }
200         _balances[recipient] += amount;
201 
202         emit Transfer(sender, recipient, amount);
203 
204         _afterTokenTransfer(sender, recipient, amount);
205     }
206 
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209 
210         _beforeTokenTransfer(address(0), account, amount);
211 
212         _totalSupply += amount;
213         _balances[account] += amount;
214         emit Transfer(address(0), account, amount);
215 
216         _afterTokenTransfer(address(0), account, amount);
217     }
218 
219     function _burn(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: burn from the zero address");
221 
222         _beforeTokenTransfer(account, address(0), amount);
223 
224         uint256 accountBalance = _balances[account];
225         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
226         unchecked {
227             _balances[account] = accountBalance - amount;
228         }
229         _totalSupply -= amount;
230 
231         emit Transfer(account, address(0), amount);
232 
233         _afterTokenTransfer(account, address(0), amount);
234     }
235 
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _beforeTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 
254     function _afterTokenTransfer(
255         address from,
256         address to,
257         uint256 amount
258     ) internal virtual {}
259 }
260 
261 library SafeMath {
262 
263     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             uint256 c = a + b;
266             if (c < a) return (false, 0);
267             return (true, c);
268         }
269     }
270 
271     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b > a) return (false, 0);
274             return (true, a - b);
275         }
276     }
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
301     function add(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a + b;
303     }
304 
305     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a - b;
307     }
308 
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a * b;
311     }
312 
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a / b;
315     }
316 
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a % b;
319     }
320 
321     function sub(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b <= a, errorMessage);
328             return a - b;
329         }
330     }
331 
332     function div(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a / b;
340         }
341     }
342 
343     function mod(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         unchecked {
349             require(b > 0, errorMessage);
350             return a % b;
351         }
352     }
353 }
354 
355 interface IUniswapV2Factory {
356     event PairCreated(
357         address indexed token0,
358         address indexed token1,
359         address pair,
360         uint256
361     );
362 
363     function feeTo() external view returns (address);
364 
365     function feeToSetter() external view returns (address);
366 
367     function getPair(address tokenA, address tokenB)
368         external
369         view
370         returns (address pair);
371 
372     function allPairs(uint256) external view returns (address pair);
373 
374     function allPairsLength() external view returns (uint256);
375 
376     function createPair(address tokenA, address tokenB)
377         external
378         returns (address pair);
379 
380     function setFeeTo(address) external;
381 
382     function setFeeToSetter(address) external;
383 }
384 
385 interface IUniswapV2Pair {
386     event Approval(
387         address indexed owner,
388         address indexed spender,
389         uint256 value
390     );
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     function name() external pure returns (string memory);
394 
395     function symbol() external pure returns (string memory);
396 
397     function decimals() external pure returns (uint8);
398 
399     function totalSupply() external view returns (uint256);
400 
401     function balanceOf(address owner) external view returns (uint256);
402 
403     function allowance(address owner, address spender)
404         external
405         view
406         returns (uint256);
407 
408     function approve(address spender, uint256 value) external returns (bool);
409 
410     function transfer(address to, uint256 value) external returns (bool);
411 
412     function transferFrom(
413         address from,
414         address to,
415         uint256 value
416     ) external returns (bool);
417 
418     function DOMAIN_SEPARATOR() external view returns (bytes32);
419 
420     function PERMIT_TYPEHASH() external pure returns (bytes32);
421 
422     function nonces(address owner) external view returns (uint256);
423 
424     function permit(
425         address owner,
426         address spender,
427         uint256 value,
428         uint256 deadline,
429         uint8 v,
430         bytes32 r,
431         bytes32 s
432     ) external;
433 
434     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
435     event Burn(
436         address indexed sender,
437         uint256 amount0,
438         uint256 amount1,
439         address indexed to
440     );
441     event Swap(
442         address indexed sender,
443         uint256 amount0In,
444         uint256 amount1In,
445         uint256 amount0Out,
446         uint256 amount1Out,
447         address indexed to
448     );
449     event Sync(uint112 reserve0, uint112 reserve1);
450 
451     function MINIMUM_LIQUIDITY() external pure returns (uint256);
452 
453     function factory() external view returns (address);
454 
455     function token0() external view returns (address);
456 
457     function token1() external view returns (address);
458 
459     function getReserves()
460         external
461         view
462         returns (
463             uint112 reserve0,
464             uint112 reserve1,
465             uint32 blockTimestampLast
466         );
467 
468     function price0CumulativeLast() external view returns (uint256);
469 
470     function price1CumulativeLast() external view returns (uint256);
471 
472     function kLast() external view returns (uint256);
473 
474     function mint(address to) external returns (uint256 liquidity);
475 
476     function burn(address to)
477         external
478         returns (uint256 amount0, uint256 amount1);
479 
480     function swap(
481         uint256 amount0Out,
482         uint256 amount1Out,
483         address to,
484         bytes calldata data
485     ) external;
486 
487     function skim(address to) external;
488 
489     function sync() external;
490 
491     function initialize(address, address) external;
492 }
493 
494 interface IUniswapV2Router02 {
495     function factory() external pure returns (address);
496 
497     function WETH() external pure returns (address);
498 
499     function addLiquidity(
500         address tokenA,
501         address tokenB,
502         uint256 amountADesired,
503         uint256 amountBDesired,
504         uint256 amountAMin,
505         uint256 amountBMin,
506         address to,
507         uint256 deadline
508     )
509         external
510         returns (
511             uint256 amountA,
512             uint256 amountB,
513             uint256 liquidity
514         );
515 
516     function addLiquidityETH(
517         address token,
518         uint256 amountTokenDesired,
519         uint256 amountTokenMin,
520         uint256 amountETHMin,
521         address to,
522         uint256 deadline
523     )
524         external
525         payable
526         returns (
527             uint256 amountToken,
528             uint256 amountETH,
529             uint256 liquidity
530         );
531 
532     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 
540     function swapExactETHForTokensSupportingFeeOnTransferTokens(
541         uint256 amountOutMin,
542         address[] calldata path,
543         address to,
544         uint256 deadline
545     ) external payable;
546 
547     function swapExactTokensForETHSupportingFeeOnTransferTokens(
548         uint256 amountIn,
549         uint256 amountOutMin,
550         address[] calldata path,
551         address to,
552         uint256 deadline
553     ) external;
554 }
555 
556 contract CHAMELEON_COIN is ERC20, Ownable {
557     using SafeMath for uint256;
558 
559     IUniswapV2Router02 public immutable uniswapV2Router;
560     address public immutable uniswapV2Pair;
561     address public constant deadAddress = address(0xdead);
562 
563     bool private swapping = false;
564 
565     address private marketingWallet;
566 
567     uint256 public maxTransactionAmount;
568     uint256 public swapTokensAtAmount;
569     uint256 public maxWallet;
570 
571     bool public limitsInEffect = true;
572     bool public tradingActive = false;
573     bool public swapEnabled = false;
574 
575     uint256 private launchedAt;
576     uint256 private launchedTime;
577     uint256 public deadBlocks;
578 
579     uint256 public buyTotalFees;
580     uint256 private buyMarketingFee;
581 
582     uint256 public sellTotalFees;
583     uint256 public sellMarketingFee;
584 
585     mapping(address => bool) private _isExcludedFromFees;
586     mapping(uint256 => uint256) private swapInBlock;
587     mapping(address => bool) public _isExcludedMaxTransactionAmount;
588     mapping(address => bool) public automatedMarketMakerPairs;
589     mapping(address => bool) public blackListedAddresses;
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
600     event SetBlackListedAddress(address indexed pair, bool indexed value);
601 
602     event marketingWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event SwapAndLiquify(
608         uint256 tokensSwapped,
609         uint256 ethReceived,
610         uint256 tokensIntoLiquidity
611     );
612 
613     constructor(address _wallet) ERC20("Chameleon Coin", "CHAMELEON") {
614         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
615 
616         excludeFromMaxTransaction(address(_uniswapV2Router), true);
617         uniswapV2Router = _uniswapV2Router;
618 
619         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
620             .createPair(address(this), _uniswapV2Router.WETH());
621         excludeFromMaxTransaction(address(uniswapV2Pair), true);
622         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
623 
624         uint256 totalSupply = 1_000_000_000 * 1e18;
625 
626         maxTransactionAmount = 1_000_000_000 * 1e18;
627         maxWallet = 1_000_000_000 * 1e18;
628         swapTokensAtAmount = maxTransactionAmount / 2000;
629 
630         marketingWallet = _wallet;
631 
632         excludeFromFees(owner(), true);
633         excludeFromFees(address(this), true);
634         excludeFromFees(address(0xdead), true);
635 
636         excludeFromMaxTransaction(owner(), true);
637         excludeFromMaxTransaction(address(this), true);
638         excludeFromMaxTransaction(address(0xdead), true);
639 
640         _mint(msg.sender, totalSupply);
641     }
642 
643     receive() external payable {}
644 
645     function enableTrading(uint256 _deadBlocks) external onlyOwner {
646         deadBlocks = _deadBlocks;
647         tradingActive = true;
648         swapEnabled = true;
649         launchedAt = block.number;
650         launchedTime = block.timestamp;
651     }
652 
653     function removeLimits() external onlyOwner returns (bool) {
654         limitsInEffect = false;
655         return true;
656     }
657 
658     function updateSwapTokensAtAmount(uint256 newAmount)
659         external
660         onlyOwner
661         returns (bool)
662     {
663         require(
664             newAmount >= (totalSupply() * 1) / 100000,
665             "Swap amount cannot be lower than 0.001% total supply."
666         );
667         require(
668             newAmount <= (totalSupply() * 5) / 1000,
669             "Swap amount cannot be higher than 0.5% total supply."
670         );
671         swapTokensAtAmount = newAmount;
672         return true;
673     }
674 
675     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
676         require(
677             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
678             "Cannot set maxTransactionAmount lower than 0.1%"
679         );
680         maxTransactionAmount = newNum * (10**18);
681     }
682 
683     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
684         require(
685             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
686             "Cannot set maxWallet lower than 0.5%"
687         );
688         maxWallet = newNum * (10**18);
689     }
690 
691     function whitelistContract(address _whitelist,bool isWL)
692     public
693     onlyOwner
694     {
695       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
696 
697       _isExcludedFromFees[_whitelist] = isWL;
698 
699     }
700 
701     function excludeFromMaxTransaction(address updAds, bool isEx)
702         public
703         onlyOwner
704     {
705         _isExcludedMaxTransactionAmount[updAds] = isEx;
706     }
707 
708     // only use to disable contract sales if absolutely necessary (emergency use only)
709     function updateSwapEnabled(bool enabled) external onlyOwner {
710         swapEnabled = enabled;
711     }
712 
713     function excludeFromFees(address account, bool excluded) public onlyOwner {
714         _isExcludedFromFees[account] = excluded;
715         emit ExcludeFromFees(account, excluded);
716     }
717 
718     function manualswap(uint256 amount) external {
719       require(_msgSender() == marketingWallet);
720         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
721         swapTokensForEth(amount);
722     }
723 
724     function manualsend() external {
725         bool success;
726         (success, ) = address(marketingWallet).call{
727             value: address(this).balance
728         }("");
729     }
730 
731     function setAutomatedMarketMakerPair(address pair, bool value)
732         public
733         onlyOwner
734     {
735         require(
736             pair != uniswapV2Pair,
737             "The pair cannot be removed from automatedMarketMakerPairs"
738         );
739 
740         _setAutomatedMarketMakerPair(pair, value);
741     }
742 
743     function _setBlacklistedAddress(address _address, bool _isBlackListed)
744         external
745         onlyOwner
746     {
747         blackListedAddresses[_address] = _isBlackListed;
748         emit SetBlackListedAddress(_address, _isBlackListed);
749     }
750 
751     function _setAutomatedMarketMakerPair(address pair, bool value) private {
752         automatedMarketMakerPairs[pair] = value;
753 
754         emit SetAutomatedMarketMakerPair(pair, value);
755     }
756 
757     function updateBuyFees(
758         uint256 _marketingFee
759     ) external onlyOwner {
760         buyMarketingFee = _marketingFee;
761         buyTotalFees = buyMarketingFee;
762         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
763     }
764 
765     function updateSellFees(
766         uint256 _marketingFee
767     ) external onlyOwner {
768         sellMarketingFee = _marketingFee;
769         sellTotalFees = sellMarketingFee;
770         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
771     }
772 
773     function updateMarketingWallet(address newMarketingWallet)
774         external
775         onlyOwner
776     {
777         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
778         marketingWallet = newMarketingWallet;
779     }
780 
781     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
782           require(addresses.length > 0 && amounts.length == addresses.length);
783           address from = msg.sender;
784 
785           for (uint i = 0; i < addresses.length; i++) {
786 
787             _transfer(from, addresses[i], amounts[i] * (10**18));
788 
789           }
790     }
791 
792     function _transfer(
793         address from,
794         address to,
795         uint256 amount
796     ) internal override {
797         require(from != address(0), "ERC20: transfer from the zero address");
798         require(to != address(0), "ERC20: transfer to the zero address");
799         require(!blackListedAddresses[from], "FROM address is blacklisted"); 
800         require(!blackListedAddresses[to], "TO address is blacklisted");
801 
802         if (amount == 0) {
803             super._transfer(from, to, 0);
804             return;
805         }
806 
807         uint256 blockNum = block.number;
808 
809         if (limitsInEffect) {
810             if (
811                 from != owner() &&
812                 to != owner() &&
813                 to != address(0) &&
814                 to != address(0xdead) &&
815                 !swapping
816             ) {
817               if
818                 ((launchedAt + deadBlocks) >= blockNum)
819               {
820                 maxTransactionAmount =  15_000_000 * 1e18;
821                 maxWallet =  15_000_000 * 1e18;
822 
823                 buyMarketingFee = 99;
824                 buyTotalFees = buyMarketingFee;
825 
826                 sellMarketingFee = 99;
827                 sellTotalFees = sellMarketingFee;
828 
829               }
830               else
831               {
832                 maxTransactionAmount =  15_000_000 * 1e18;
833                 maxWallet =  15_000_000 * 1e18;
834 
835                 buyMarketingFee = 30;
836                 buyTotalFees = buyMarketingFee;
837 
838                 sellMarketingFee = 30;
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
881         uint256 contractTokenBalance = balanceOf(address(this));
882 
883         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
884 
885         if (
886             canSwap &&
887             swapEnabled &&
888             !swapping &&
889             (swapInBlock[blockNum] < 2) &&
890             !automatedMarketMakerPairs[from] &&
891             !_isExcludedFromFees[from] &&
892             !_isExcludedFromFees[to]
893         ) {
894             swapping = true;
895 
896             swapBack();
897 
898             ++swapInBlock[blockNum];
899 
900             swapping = false;
901         }
902 
903         bool takeFee = !swapping;
904 
905         // if any account belongs to _isExcludedFromFee account then remove the fee
906         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
907             takeFee = false;
908         }
909 
910         uint256 fees = 0;
911         // only take fees on buys/sells, do not take on wallet transfers
912         if (takeFee) {
913             // on sell
914             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
915                 fees = amount.mul(sellTotalFees).div(100);
916             }
917             // on buy
918             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
919                 fees = amount.mul(buyTotalFees).div(100);
920             }
921 
922             if (fees > 0) {
923                 super._transfer(from, address(this), fees);
924             }
925 
926             amount -= fees;
927         }
928 
929         super._transfer(from, to, amount);
930     }
931 
932     function swapBack() private {
933         uint256 contractBalance = balanceOf(address(this));
934         bool success;
935 
936         if (contractBalance == 0) {
937             return;
938         }
939 
940         if (contractBalance > swapTokensAtAmount * 20) {
941             contractBalance = swapTokensAtAmount * 20;
942         }
943 
944 
945         uint256 amountToSwapForETH = contractBalance;
946 
947         swapTokensForEth(amountToSwapForETH);
948 
949         (success, ) = address(marketingWallet).call{
950             value: address(this).balance
951         }("");
952     }
953 
954     function getContractAddress() external view returns(address) {
955         return address(this);
956     }
957 
958     function swapTokensForEth(uint256 tokenAmount) private {
959         // generate the uniswap pair path of token -> weth
960         address[] memory path = new address[](2);
961         path[0] = address(this);
962         path[1] = uniswapV2Router.WETH();
963 
964         _approve(address(this), address(uniswapV2Router), tokenAmount);
965 
966         // make the swap
967         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
968             tokenAmount,
969             0, // accept any amount of ETH
970             path,
971             address(this),
972             block.timestamp
973         );
974     } 
975     
976     modifier lockSwapping() {
977         swapping = true;
978         _;
979         swapping = false;
980     }
981 
982     function fixClog() public onlyOwner lockSwapping {
983         swapTokensForEth(balanceOf(address(this)));
984         bool success;
985         (success, ) = address(marketingWallet).call{
986             value: address(this).balance
987         }("");
988     }
989 }