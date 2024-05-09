1 /*
2                                                                            
3    _|_|_|    _|_|    _|_|_|_|  _|_|_|_|      _|_|_|  _|      _|  _|    _|  
4  _|        _|    _|  _|        _|              _|    _|_|    _|  _|    _|  
5    _|_|    _|_|_|_|  _|_|_|    _|_|_|          _|    _|  _|  _|  _|    _|  
6        _|  _|    _|  _|        _|              _|    _|    _|_|  _|    _|  
7  _|_|_|    _|    _|  _|        _|_|_|_|      _|_|_|  _|      _|    _|_|    
8                                                                            
9                                                                            
10 Telegram: https://t.me/safeinucoin
11 Twitter: https://twitter.com/safeinucoin
12 Web: https://www.safeinu.com/
13 
14 */
15 
16 // SPDX-License-Identifier: UNLICENSED
17 
18 pragma solidity 0.8.21;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         _transferOwnership(address(0));
52     }
53 
54     function transferOwnership(address newOwner) public virtual onlyOwner {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         _transferOwnership(newOwner);
57     }
58 
59     function _transferOwnership(address newOwner) internal virtual {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 interface IERC20 {
67 
68     function totalSupply() external view returns (uint256);
69 
70     function balanceOf(address account) external view returns (uint256);
71 
72     function transfer(address recipient, uint256 amount) external returns (bool);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90 
91     function name() external view returns (string memory);
92 
93     function symbol() external view returns (string memory);
94 
95     function decimals() external view returns (uint8);
96 }
97 
98 contract ERC20 is Context, IERC20, IERC20Metadata {
99     mapping(address => uint256) private _balances;
100 
101     mapping(address => mapping(address => uint256)) private _allowances;
102 
103     uint256 private _totalSupply;
104 
105     string private _name;
106     string private _symbol;
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
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121 
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125 
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133 
134     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138 
139     function allowance(address owner, address spender) public view virtual override returns (uint256) {
140         return _allowances[owner][spender];
141     }
142 
143     function approve(address spender, uint256 amount) public virtual override returns (bool) {
144         _approve(_msgSender(), spender, amount);
145         return true;
146     }
147 
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) public virtual override returns (bool) {
153         _transfer(sender, recipient, amount);
154 
155         uint256 currentAllowance = _allowances[sender][_msgSender()];
156         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
157         unchecked {
158             _approve(sender, _msgSender(), currentAllowance - amount);
159         }
160 
161         return true;
162     }
163 
164     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
165         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
166         return true;
167     }
168 
169     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
170         uint256 currentAllowance = _allowances[_msgSender()][spender];
171         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
172         unchecked {
173             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
174         }
175 
176         return true;
177     }
178 
179     function _transfer(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) internal virtual {
184         require(sender != address(0), "ERC20: transfer from the zero address");
185         require(recipient != address(0), "ERC20: transfer to the zero address");
186 
187         _beforeTokenTransfer(sender, recipient, amount);
188 
189         uint256 senderBalance = _balances[sender];
190         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
191         unchecked {
192             _balances[sender] = senderBalance - amount;
193         }
194         _balances[recipient] += amount;
195 
196         emit Transfer(sender, recipient, amount);
197 
198         _afterTokenTransfer(sender, recipient, amount);
199     }
200 
201     function _mint(address account, uint256 amount) internal virtual {
202         require(account != address(0), "ERC20: mint to the zero address");
203 
204         _beforeTokenTransfer(address(0), account, amount);
205 
206         _totalSupply += amount;
207         _balances[account] += amount;
208         emit Transfer(address(0), account, amount);
209 
210         _afterTokenTransfer(address(0), account, amount);
211     }
212 
213     function _burn(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: burn from the zero address");
215 
216         _beforeTokenTransfer(account, address(0), amount);
217 
218         uint256 accountBalance = _balances[account];
219         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
220         unchecked {
221             _balances[account] = accountBalance - amount;
222         }
223         _totalSupply -= amount;
224 
225         emit Transfer(account, address(0), amount);
226 
227         _afterTokenTransfer(account, address(0), amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _beforeTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 
248     function _afterTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 }
254 
255 library SafeMath {
256 
257     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             uint256 c = a + b;
260             if (c < a) return (false, 0);
261             return (true, c);
262         }
263     }
264 
265     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b > a) return (false, 0);
268             return (true, a - b);
269         }
270     }
271 
272     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (a == 0) return (true, 0);
275             uint256 c = a * b;
276             if (c / a != b) return (false, 0);
277             return (true, c);
278         }
279     }
280 
281     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (b == 0) return (false, 0);
284             return (true, a / b);
285         }
286     }
287 
288     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b == 0) return (false, 0);
291             return (true, a % b);
292         }
293     }
294 
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a + b;
297     }
298 
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a - b;
301     }
302 
303     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a * b;
305     }
306 
307     function div(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a / b;
309     }
310 
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a % b;
313     }
314 
315     function sub(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b <= a, errorMessage);
322             return a - b;
323         }
324     }
325 
326     function div(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         unchecked {
332             require(b > 0, errorMessage);
333             return a / b;
334         }
335     }
336 
337     function mod(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         unchecked {
343             require(b > 0, errorMessage);
344             return a % b;
345         }
346     }
347 }
348 
349 interface IUniswapV2Factory {
350     event PairCreated(
351         address indexed token0,
352         address indexed token1,
353         address pair,
354         uint256
355     );
356 
357     function feeTo() external view returns (address);
358 
359     function feeToSetter() external view returns (address);
360 
361     function getPair(address tokenA, address tokenB)
362         external
363         view
364         returns (address pair);
365 
366     function allPairs(uint256) external view returns (address pair);
367 
368     function allPairsLength() external view returns (uint256);
369 
370     function createPair(address tokenA, address tokenB)
371         external
372         returns (address pair);
373 
374     function setFeeTo(address) external;
375 
376     function setFeeToSetter(address) external;
377 }
378 
379 interface IUniswapV2Pair {
380     event Approval(
381         address indexed owner,
382         address indexed spender,
383         uint256 value
384     );
385     event Transfer(address indexed from, address indexed to, uint256 value);
386 
387     function name() external pure returns (string memory);
388 
389     function symbol() external pure returns (string memory);
390 
391     function decimals() external pure returns (uint8);
392 
393     function totalSupply() external view returns (uint256);
394 
395     function balanceOf(address owner) external view returns (uint256);
396 
397     function allowance(address owner, address spender)
398         external
399         view
400         returns (uint256);
401 
402     function approve(address spender, uint256 value) external returns (bool);
403 
404     function transfer(address to, uint256 value) external returns (bool);
405 
406     function transferFrom(
407         address from,
408         address to,
409         uint256 value
410     ) external returns (bool);
411 
412     function DOMAIN_SEPARATOR() external view returns (bytes32);
413 
414     function PERMIT_TYPEHASH() external pure returns (bytes32);
415 
416     function nonces(address owner) external view returns (uint256);
417 
418     function permit(
419         address owner,
420         address spender,
421         uint256 value,
422         uint256 deadline,
423         uint8 v,
424         bytes32 r,
425         bytes32 s
426     ) external;
427 
428     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
429     event Burn(
430         address indexed sender,
431         uint256 amount0,
432         uint256 amount1,
433         address indexed to
434     );
435     event Swap(
436         address indexed sender,
437         uint256 amount0In,
438         uint256 amount1In,
439         uint256 amount0Out,
440         uint256 amount1Out,
441         address indexed to
442     );
443     event Sync(uint112 reserve0, uint112 reserve1);
444 
445     function MINIMUM_LIQUIDITY() external pure returns (uint256);
446 
447     function factory() external view returns (address);
448 
449     function token0() external view returns (address);
450 
451     function token1() external view returns (address);
452 
453     function getReserves()
454         external
455         view
456         returns (
457             uint112 reserve0,
458             uint112 reserve1,
459             uint32 blockTimestampLast
460         );
461 
462     function price0CumulativeLast() external view returns (uint256);
463 
464     function price1CumulativeLast() external view returns (uint256);
465 
466     function kLast() external view returns (uint256);
467 
468     function mint(address to) external returns (uint256 liquidity);
469 
470     function burn(address to)
471         external
472         returns (uint256 amount0, uint256 amount1);
473 
474     function swap(
475         uint256 amount0Out,
476         uint256 amount1Out,
477         address to,
478         bytes calldata data
479     ) external;
480 
481     function skim(address to) external;
482 
483     function sync() external;
484 
485     function initialize(address, address) external;
486 }
487 
488 interface IUniswapV2Router02 {
489     function factory() external pure returns (address);
490 
491     function WETH() external pure returns (address);
492 
493     function addLiquidity(
494         address tokenA,
495         address tokenB,
496         uint256 amountADesired,
497         uint256 amountBDesired,
498         uint256 amountAMin,
499         uint256 amountBMin,
500         address to,
501         uint256 deadline
502     )
503         external
504         returns (
505             uint256 amountA,
506             uint256 amountB,
507             uint256 liquidity
508         );
509 
510     function addLiquidityETH(
511         address token,
512         uint256 amountTokenDesired,
513         uint256 amountTokenMin,
514         uint256 amountETHMin,
515         address to,
516         uint256 deadline
517     )
518         external
519         payable
520         returns (
521             uint256 amountToken,
522             uint256 amountETH,
523             uint256 liquidity
524         );
525 
526     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
527         uint256 amountIn,
528         uint256 amountOutMin,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external;
533 
534     function swapExactETHForTokensSupportingFeeOnTransferTokens(
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external payable;
540 
541     function swapExactTokensForETHSupportingFeeOnTransferTokens(
542         uint256 amountIn,
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external;
548 }
549 
550 contract SafeInu is ERC20, Ownable {
551     using SafeMath for uint256;
552 
553     IUniswapV2Router02 public immutable uniswapV2Router;
554     address public immutable uniswapV2Pair;
555     address public constant deadAddress = address(0xdead);
556 
557     bool private swapping;
558 
559     address private marketingWallet;
560 
561     uint256 public maxTransactionAmount;
562     uint256 public swapTokensAtAmount;
563     uint256 public maxWallet;
564 
565     bool public limitsInEffect = true;
566     bool public tradingActive = false;
567     bool public swapEnabled = false;
568 
569     uint256 private launchedAt;
570     uint256 private launchedTime;
571     uint256 public deadBlocks;
572 
573     uint256 public buyTotalFees;
574     uint256 private buyMarketingFee;
575 
576     uint256 public sellTotalFees;
577     uint256 public sellMarketingFee;
578 
579     mapping(address => bool) private _isExcludedFromFees;
580     mapping(uint256 => uint256) private swapInBlock;
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
605     constructor(address _wallet1) ERC20(unicode"SafeInu", unicode"SAFEINU") {
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
616         uint256 totalSupply = 1_000_000_000 * 1e18;
617 
618         maxTransactionAmount = 20_000_000 * 1e18;
619         maxWallet = 20_000_000 * 1e18;
620         swapTokensAtAmount = totalSupply * 2 / 1000;
621 
622         marketingWallet = _wallet1;
623 
624         excludeFromFees(owner(), true);
625         excludeFromFees(address(this), true);
626         excludeFromFees(address(0xdead), true);
627 
628         excludeFromMaxTransaction(owner(), true);
629         excludeFromMaxTransaction(address(this), true);
630         excludeFromMaxTransaction(address(0xdead), true);
631 
632         _mint(msg.sender, totalSupply);
633     }
634 
635     receive() external payable {}
636 
637     function enableTrading(uint256 _deadBlocks) external onlyOwner {
638         deadBlocks = _deadBlocks;
639         tradingActive = true;
640         swapEnabled = true;
641         launchedAt = block.number;
642         launchedTime = block.timestamp;
643     }
644 
645     function removeLimits() external onlyOwner returns (bool) {
646         limitsInEffect = false;
647         return true;
648     }
649 
650     function updateSwapTokensAtAmount(uint256 newAmount)
651         external
652         onlyOwner
653         returns (bool)
654     {
655         require(
656             newAmount >= (totalSupply() * 1) / 100000,
657             "Swap amount cannot be lower than 0.001% total supply."
658         );
659         require(
660             newAmount <= (totalSupply() * 5) / 1000,
661             "Swap amount cannot be higher than 0.5% total supply."
662         );
663         swapTokensAtAmount = newAmount;
664         return true;
665     }
666 
667     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
668         require(
669             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
670             "Cannot set maxTransactionAmount lower than 0.1%"
671         );
672         maxTransactionAmount = newNum * (10**18);
673     }
674 
675     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
676         require(
677             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
678             "Cannot set maxWallet lower than 0.5%"
679         );
680         maxWallet = newNum * (10**18);
681     }
682 
683     function whitelistContract(address _whitelist,bool isWL)
684     public
685     onlyOwner
686     {
687       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
688 
689       _isExcludedFromFees[_whitelist] = isWL;
690 
691     }
692 
693     function excludeFromMaxTransaction(address updAds, bool isEx)
694         public
695         onlyOwner
696     {
697         _isExcludedMaxTransactionAmount[updAds] = isEx;
698     }
699 
700     // only use to disable contract sales if absolutely necessary (emergency use only)
701     function updateSwapEnabled(bool enabled) external onlyOwner {
702         swapEnabled = enabled;
703     }
704 
705     function excludeFromFees(address account, bool excluded) public onlyOwner {
706         _isExcludedFromFees[account] = excluded;
707         emit ExcludeFromFees(account, excluded);
708     }
709 
710     function manualswap(uint256 amount) external {
711       require(_msgSender() == marketingWallet);
712         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
713         swapTokensForEth(amount);
714     }
715 
716     function manualsend() external {
717         bool success;
718         (success, ) = address(marketingWallet).call{
719             value: address(this).balance
720         }("");
721     }
722 
723         function setAutomatedMarketMakerPair(address pair, bool value)
724         public
725         onlyOwner
726     {
727         require(
728             pair != uniswapV2Pair,
729             "The pair cannot be removed from automatedMarketMakerPairs"
730         );
731 
732         _setAutomatedMarketMakerPair(pair, value);
733     }
734 
735     function _setAutomatedMarketMakerPair(address pair, bool value) private {
736         automatedMarketMakerPairs[pair] = value;
737 
738         emit SetAutomatedMarketMakerPair(pair, value);
739     }
740 
741     function updateBuyFees(
742         uint256 _marketingFee
743     ) external onlyOwner {
744         buyMarketingFee = _marketingFee;
745         buyTotalFees = buyMarketingFee;
746         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
747     }
748 
749     function updateSellFees(
750         uint256 _marketingFee
751     ) external onlyOwner {
752         sellMarketingFee = _marketingFee;
753         sellTotalFees = sellMarketingFee;
754         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
755     }
756 
757     function updateMarketingWallet(address newMarketingWallet)
758         external
759         onlyOwner
760     {
761         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
762         marketingWallet = newMarketingWallet;
763     }
764 
765     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
766           require(addresses.length > 0 && amounts.length == addresses.length);
767           address from = msg.sender;
768 
769           for (uint i = 0; i < addresses.length; i++) {
770 
771             _transfer(from, addresses[i], amounts[i] * (10**18));
772 
773           }
774     }
775 
776     function _transfer(
777         address from,
778         address to,
779         uint256 amount
780     ) internal override {
781         require(from != address(0), "ERC20: transfer from the zero address");
782         require(to != address(0), "ERC20: transfer to the zero address");
783 
784         if (amount == 0) {
785             super._transfer(from, to, 0);
786             return;
787         }
788 
789         uint256 blockNum = block.number;
790 
791         if (limitsInEffect) {
792             if (
793                 from != owner() &&
794                 to != owner() &&
795                 to != address(0) &&
796                 to != address(0xdead) &&
797                 !swapping
798             ) {
799               if
800                 ((launchedAt + deadBlocks) >= blockNum)
801               {
802                 buyMarketingFee = 25;
803                 buyTotalFees = buyMarketingFee;
804 
805                 sellMarketingFee = 25;
806                 sellTotalFees = sellMarketingFee;
807 
808               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 32)
809               {
810                 buyMarketingFee = 15;
811                 buyTotalFees = buyMarketingFee;
812 
813                 sellMarketingFee = 15;
814                 sellTotalFees = sellMarketingFee;
815               }
816               else
817               {
818                 buyMarketingFee = 2;
819                 buyTotalFees = buyMarketingFee;
820 
821                 sellMarketingFee = 2;
822                 sellTotalFees = sellMarketingFee;
823               }
824 
825                 if (!tradingActive) {
826                     require(
827                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
828                         "Trading is not active."
829                     );
830                 }
831 
832                 //when buy
833                 if (
834                     automatedMarketMakerPairs[from] &&
835                     !_isExcludedMaxTransactionAmount[to]
836                 ) {
837                     require(
838                         amount <= maxTransactionAmount,
839                         "Buy transfer amount exceeds the maxTransactionAmount."
840                     );
841                     require(
842                         amount + balanceOf(to) <= maxWallet,
843                         "Max wallet exceeded"
844                     );
845                 }
846                 //when sell
847                 else if (
848                     automatedMarketMakerPairs[to] &&
849                     !_isExcludedMaxTransactionAmount[from]
850                 ) {
851                     require(
852                         amount <= maxTransactionAmount,
853                         "Sell transfer amount exceeds the maxTransactionAmount."
854                     );
855                 } else if (!_isExcludedMaxTransactionAmount[to]) {
856                     require(
857                         amount + balanceOf(to) <= maxWallet,
858                         "Max wallet exceeded"
859                     );
860                 }
861             }
862         }
863 
864         uint256 contractTokenBalance = balanceOf(address(this));
865 
866         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
867 
868         if (
869             canSwap &&
870             swapEnabled &&
871             !swapping &&
872             (swapInBlock[blockNum] < 2) &&
873             !automatedMarketMakerPairs[from] &&
874             !_isExcludedFromFees[from] &&
875             !_isExcludedFromFees[to]
876         ) {
877             swapping = true;
878 
879             swapBack();
880 
881             ++swapInBlock[blockNum];
882 
883             swapping = false;
884         }
885 
886         bool takeFee = !swapping;
887 
888         // if any account belongs to _isExcludedFromFee account then remove the fee
889         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
890             takeFee = false;
891         }
892 
893         uint256 fees = 0;
894         // only take fees on buys/sells, do not take on wallet transfers
895         if (takeFee) {
896             // on sell
897             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
898                 fees = amount.mul(sellTotalFees).div(100);
899             }
900             // on buy
901             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
902                 fees = amount.mul(buyTotalFees).div(100);
903             }
904 
905             if (fees > 0) {
906                 super._transfer(from, address(this), fees);
907             }
908 
909             amount -= fees;
910         }
911 
912         super._transfer(from, to, amount);
913     }
914 
915     function swapBack() private {
916         uint256 contractBalance = balanceOf(address(this));
917         bool success;
918 
919         if (contractBalance == 0) {
920             return;
921         }
922 
923         if (contractBalance > swapTokensAtAmount * 20) {
924             contractBalance = swapTokensAtAmount * 20;
925         }
926 
927 
928         uint256 amountToSwapForETH = contractBalance;
929 
930         swapTokensForEth(amountToSwapForETH);
931 
932         (success, ) = address(marketingWallet).call{
933             value: address(this).balance
934         }("");
935     }
936 
937     function getTimestamp(uint x) external pure returns(uint) {
938         return x + 11;
939     }
940 
941     function swapTokensForEth(uint256 tokenAmount) private {
942         // generate the uniswap pair path of token -> weth
943         address[] memory path = new address[](2);
944         path[0] = address(this);
945         path[1] = uniswapV2Router.WETH();
946 
947         _approve(address(this), address(uniswapV2Router), tokenAmount);
948 
949         // make the swap
950         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
951             tokenAmount,
952             0, // accept any amount of ETH
953             path,
954             address(this),
955             block.timestamp
956         );
957     }
958 
959 }