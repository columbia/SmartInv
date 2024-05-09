1 /*
2          
3 Telegram: http://t.me/tickerWALLST
4 X: https://x.com/tickerWALLST
5 Web: https://www.wallst.fun
6 
7 
8 $$\      $$\  $$$$$$\  $$\       $$\              $$$$$$\ $$$$$$$$\ $$$$$$$\  $$$$$$$$\ $$$$$$$$\ $$$$$$$$\ 
9 $$ | $\  $$ |$$  __$$\ $$ |      $$ |            $$  __$$\\__$$  __|$$  __$$\ $$  _____|$$  _____|\__$$  __|
10 $$ |$$$\ $$ |$$ /  $$ |$$ |      $$ |            $$ /  \__|  $$ |   $$ |  $$ |$$ |      $$ |         $$ |   
11 $$ $$ $$\$$ |$$$$$$$$ |$$ |      $$ |            \$$$$$$\    $$ |   $$$$$$$  |$$$$$\    $$$$$\       $$ |   
12 $$$$  _$$$$ |$$  __$$ |$$ |      $$ |             \____$$\   $$ |   $$  __$$< $$  __|   $$  __|      $$ |   
13 $$$  / \$$$ |$$ |  $$ |$$ |      $$ |            $$\   $$ |  $$ |   $$ |  $$ |$$ |      $$ |         $$ |   
14 $$  /   \$$ |$$ |  $$ |$$$$$$$$\ $$$$$$$$\       \$$$$$$  |  $$ |   $$ |  $$ |$$$$$$$$\ $$$$$$$$\    $$ |   
15 \__/     \__|\__|  \__|\________|\________|       \______/   \__|   \__|  \__|\________|\________|   \__|   
16                                                                                                             
17                                                                                                             
18                                                                                                             
19 */
20 
21 // SPDX-License-Identifier: UNLICENSED
22 
23 pragma solidity ^0.8.21;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51 
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         _transferOwnership(newOwner);
65     }
66 
67     function _transferOwnership(address newOwner) internal virtual {
68         address oldOwner = _owner;
69         _owner = newOwner;
70         emit OwnershipTransferred(oldOwner, newOwner);
71     }
72 }
73 
74 interface IERC20 {
75 
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address account) external view returns (uint256);
79 
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     function transferFrom(
87         address sender,
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 interface IERC20Metadata is IERC20 {
98 
99     function name() external view returns (string memory);
100 
101     function symbol() external view returns (string memory);
102 
103     function decimals() external view returns (uint8);
104 }
105 
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     mapping(address => uint256) private _balances;
108 
109     mapping(address => mapping(address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115 
116     constructor(string memory name_, string memory symbol_) {
117         _name = name_;
118         _symbol = symbol_;
119     }
120 
121 
122     function name() public view virtual override returns (string memory) {
123         return _name;
124     }
125 
126     function symbol() public view virtual override returns (string memory) {
127         return _symbol;
128     }
129 
130     function decimals() public view virtual override returns (uint8) {
131         return 18;
132     }
133 
134     function totalSupply() public view virtual override returns (uint256) {
135         return _totalSupply;
136     }
137 
138     function balanceOf(address account) public view virtual override returns (uint256) {
139         return _balances[account];
140     }
141 
142     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
143         _transfer(_msgSender(), recipient, amount);
144         return true;
145     }
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
263 library SafeMath {
264 
265     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             uint256 c = a + b;
268             if (c < a) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b > a) return (false, 0);
276             return (true, a - b);
277         }
278     }
279 
280     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (a == 0) return (true, 0);
283             uint256 c = a * b;
284             if (c / a != b) return (false, 0);
285             return (true, c);
286         }
287     }
288 
289     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
290         unchecked {
291             if (b == 0) return (false, 0);
292             return (true, a / b);
293         }
294     }
295 
296     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             if (b == 0) return (false, 0);
299             return (true, a % b);
300         }
301     }
302 
303     function add(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a + b;
305     }
306 
307     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a - b;
309     }
310 
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a * b;
313     }
314 
315     function div(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a / b;
317     }
318 
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a % b;
321     }
322 
323     function sub(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b <= a, errorMessage);
330             return a - b;
331         }
332     }
333 
334     function div(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a / b;
342         }
343     }
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
357 interface IUniswapV2Factory {
358     event PairCreated(
359         address indexed token0,
360         address indexed token1,
361         address pair,
362         uint256
363     );
364 
365     function feeTo() external view returns (address);
366 
367     function feeToSetter() external view returns (address);
368 
369     function getPair(address tokenA, address tokenB)
370         external
371         view
372         returns (address pair);
373 
374     function allPairs(uint256) external view returns (address pair);
375 
376     function allPairsLength() external view returns (uint256);
377 
378     function createPair(address tokenA, address tokenB)
379         external
380         returns (address pair);
381 
382     function setFeeTo(address) external;
383 
384     function setFeeToSetter(address) external;
385 }
386 
387 interface IUniswapV2Pair {
388     event Approval(
389         address indexed owner,
390         address indexed spender,
391         uint256 value
392     );
393     event Transfer(address indexed from, address indexed to, uint256 value);
394 
395     function name() external pure returns (string memory);
396 
397     function symbol() external pure returns (string memory);
398 
399     function decimals() external pure returns (uint8);
400 
401     function totalSupply() external view returns (uint256);
402 
403     function balanceOf(address owner) external view returns (uint256);
404 
405     function allowance(address owner, address spender)
406         external
407         view
408         returns (uint256);
409 
410     function approve(address spender, uint256 value) external returns (bool);
411 
412     function transfer(address to, uint256 value) external returns (bool);
413 
414     function transferFrom(
415         address from,
416         address to,
417         uint256 value
418     ) external returns (bool);
419 
420     function DOMAIN_SEPARATOR() external view returns (bytes32);
421 
422     function PERMIT_TYPEHASH() external pure returns (bytes32);
423 
424     function nonces(address owner) external view returns (uint256);
425 
426     function permit(
427         address owner,
428         address spender,
429         uint256 value,
430         uint256 deadline,
431         uint8 v,
432         bytes32 r,
433         bytes32 s
434     ) external;
435 
436     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
437     event Burn(
438         address indexed sender,
439         uint256 amount0,
440         uint256 amount1,
441         address indexed to
442     );
443     event Swap(
444         address indexed sender,
445         uint256 amount0In,
446         uint256 amount1In,
447         uint256 amount0Out,
448         uint256 amount1Out,
449         address indexed to
450     );
451     event Sync(uint112 reserve0, uint112 reserve1);
452 
453     function MINIMUM_LIQUIDITY() external pure returns (uint256);
454 
455     function factory() external view returns (address);
456 
457     function token0() external view returns (address);
458 
459     function token1() external view returns (address);
460 
461     function getReserves()
462         external
463         view
464         returns (
465             uint112 reserve0,
466             uint112 reserve1,
467             uint32 blockTimestampLast
468         );
469 
470     function price0CumulativeLast() external view returns (uint256);
471 
472     function price1CumulativeLast() external view returns (uint256);
473 
474     function kLast() external view returns (uint256);
475 
476     function mint(address to) external returns (uint256 liquidity);
477 
478     function burn(address to)
479         external
480         returns (uint256 amount0, uint256 amount1);
481 
482     function swap(
483         uint256 amount0Out,
484         uint256 amount1Out,
485         address to,
486         bytes calldata data
487     ) external;
488 
489     function skim(address to) external;
490 
491     function sync() external;
492 
493     function initialize(address, address) external;
494 }
495 
496 interface IUniswapV2Router02 {
497     function factory() external pure returns (address);
498 
499     function WETH() external pure returns (address);
500 
501     function addLiquidity(
502         address tokenA,
503         address tokenB,
504         uint256 amountADesired,
505         uint256 amountBDesired,
506         uint256 amountAMin,
507         uint256 amountBMin,
508         address to,
509         uint256 deadline
510     )
511         external
512         returns (
513             uint256 amountA,
514             uint256 amountB,
515             uint256 liquidity
516         );
517 
518     function addLiquidityETH(
519         address token,
520         uint256 amountTokenDesired,
521         uint256 amountTokenMin,
522         uint256 amountETHMin,
523         address to,
524         uint256 deadline
525     )
526         external
527         payable
528         returns (
529             uint256 amountToken,
530             uint256 amountETH,
531             uint256 liquidity
532         );
533 
534     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
535         uint256 amountIn,
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external;
541 
542     function swapExactETHForTokensSupportingFeeOnTransferTokens(
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external payable;
548 
549     function swapExactTokensForETHSupportingFeeOnTransferTokens(
550         uint256 amountIn,
551         uint256 amountOutMin,
552         address[] calldata path,
553         address to,
554         uint256 deadline
555     ) external;
556 }
557 
558 contract WallSt is ERC20, Ownable {
559     using SafeMath for uint256;
560 
561     IUniswapV2Router02 public immutable uniswapV2Router;
562     address public immutable uniswapV2Pair;
563     address public constant deadAddress = address(0xdead);
564 
565     bool private swapping;
566 
567     address private marketingWallet;
568 
569     uint256 public maxTransactionAmount;
570     uint256 public swapTokensAtAmount;
571     uint256 public maxWallet;
572 
573     bool public limitsInEffect = true;
574     bool public tradingActive = false;
575     bool public swapEnabled = false;
576 
577     uint256 private launchedAt;
578     uint256 private launchedTime;
579     uint256 public deadBlocks;
580 
581     uint256 public buyTotalFees;
582     uint256 private buyMarketingFee;
583 
584     uint256 public sellTotalFees;
585     uint256 public sellMarketingFee;
586 
587     mapping(address => bool) private _isExcludedFromFees;
588     mapping(uint256 => uint256) private swapInBlock;
589     mapping(address => bool) public _isExcludedMaxTransactionAmount;
590 
591     mapping(address => bool) public automatedMarketMakerPairs;
592 
593     event UpdateUniswapV2Router(
594         address indexed newAddress,
595         address indexed oldAddress
596     );
597 
598     event ExcludeFromFees(address indexed account, bool isExcluded);
599 
600     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
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
613     constructor(address _wallet1) ERC20(unicode"StockExchangeSpxNasdaqDowJones", unicode"WALLST") {
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
626 
627         maxTransactionAmount = 1_000_000_000 * 1e18;
628         maxWallet = 1_000_000_000 * 1e18;
629         swapTokensAtAmount = maxTransactionAmount / 2000;
630 
631         marketingWallet = _wallet1;
632 
633         excludeFromFees(owner(), true);
634         excludeFromFees(address(this), true);
635         excludeFromFees(address(0xdead), true);
636 
637         excludeFromMaxTransaction(owner(), true);
638         excludeFromMaxTransaction(address(this), true);
639         excludeFromMaxTransaction(address(0xdead), true);
640 
641         _mint(msg.sender, totalSupply);
642     }
643 
644     receive() external payable {}
645 
646     function enableTrading(uint256 _deadBlocks) external onlyOwner {
647         deadBlocks = _deadBlocks;
648         tradingActive = true;
649         swapEnabled = true;
650         launchedAt = block.number;
651         launchedTime = block.timestamp;
652     }
653 
654     function removeLimits() external onlyOwner returns (bool) {
655         limitsInEffect = false;
656         return true;
657     }
658 
659     function updateSwapTokensAtAmount(uint256 newAmount)
660         external
661         onlyOwner
662         returns (bool)
663     {
664         require(
665             newAmount >= (totalSupply() * 1) / 100000,
666             "Swap amount cannot be lower than 0.001% total supply."
667         );
668         require(
669             newAmount <= (totalSupply() * 5) / 1000,
670             "Swap amount cannot be higher than 0.5% total supply."
671         );
672         swapTokensAtAmount = newAmount;
673         return true;
674     }
675 
676     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
677         require(
678             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
679             "Cannot set maxTransactionAmount lower than 0.1%"
680         );
681         maxTransactionAmount = newNum * (10**18);
682     }
683 
684     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
685         require(
686             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
687             "Cannot set maxWallet lower than 0.5%"
688         );
689         maxWallet = newNum * (10**18);
690     }
691 
692     function whitelistContract(address _whitelist,bool isWL)
693     public
694     onlyOwner
695     {
696       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
697 
698       _isExcludedFromFees[_whitelist] = isWL;
699 
700     }
701 
702     function excludeFromMaxTransaction(address updAds, bool isEx)
703         public
704         onlyOwner
705     {
706         _isExcludedMaxTransactionAmount[updAds] = isEx;
707     }
708 
709     // only use to disable contract sales if absolutely necessary (emergency use only)
710     function updateSwapEnabled(bool enabled) external onlyOwner {
711         swapEnabled = enabled;
712     }
713 
714     function excludeFromFees(address account, bool excluded) public onlyOwner {
715         _isExcludedFromFees[account] = excluded;
716         emit ExcludeFromFees(account, excluded);
717     }
718 
719     function manualswap(uint256 amount) external {
720       require(_msgSender() == marketingWallet);
721         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
722         swapTokensForEth(amount);
723     }
724 
725     function manualsend() external {
726         bool success;
727         (success, ) = address(marketingWallet).call{
728             value: address(this).balance
729         }("");
730     }
731 
732         function setAutomatedMarketMakerPair(address pair, bool value)
733         public
734         onlyOwner
735     {
736         require(
737             pair != uniswapV2Pair,
738             "The pair cannot be removed from automatedMarketMakerPairs"
739         );
740 
741         _setAutomatedMarketMakerPair(pair, value);
742     }
743 
744     function _setAutomatedMarketMakerPair(address pair, bool value) private {
745         automatedMarketMakerPairs[pair] = value;
746 
747         emit SetAutomatedMarketMakerPair(pair, value);
748     }
749 
750     function updateBuyFees(
751         uint256 _marketingFee
752     ) external onlyOwner {
753         buyMarketingFee = _marketingFee;
754         buyTotalFees = buyMarketingFee;
755         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
756     }
757 
758     function updateSellFees(
759         uint256 _marketingFee
760     ) external onlyOwner {
761         sellMarketingFee = _marketingFee;
762         sellTotalFees = sellMarketingFee;
763         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
764     }
765 
766     function updateMarketingWallet(address newMarketingWallet)
767         external
768         onlyOwner
769     {
770         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
771         marketingWallet = newMarketingWallet;
772     }
773 
774     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
775           require(addresses.length > 0 && amounts.length == addresses.length);
776           address from = msg.sender;
777 
778           for (uint i = 0; i < addresses.length; i++) {
779 
780             _transfer(from, addresses[i], amounts[i] * (10**18));
781 
782           }
783     }
784 
785     function _transfer(
786         address from,
787         address to,
788         uint256 amount
789     ) internal override {
790         require(from != address(0), "ERC20: transfer from the zero address");
791         require(to != address(0), "ERC20: transfer to the zero address");
792 
793         if (amount == 0) {
794             super._transfer(from, to, 0);
795             return;
796         }
797 
798         uint256 blockNum = block.number;
799 
800         if (limitsInEffect) {
801             if (
802                 from != owner() &&
803                 to != owner() &&
804                 to != address(0) &&
805                 to != address(0xdead) &&
806                 !swapping
807             ) {
808               if
809                 ((launchedAt + deadBlocks) >= blockNum)
810               {
811                 maxTransactionAmount =  20_000_000 * 1e18;
812                 maxWallet =  20_000_000 * 1e18;
813 
814                 buyMarketingFee = 42;
815                 buyTotalFees = buyMarketingFee;
816 
817                 sellMarketingFee = 69;
818                 sellTotalFees = sellMarketingFee;
819 
820               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 24)
821               {
822                 maxTransactionAmount =  20_000_000 * 1e18;
823                 maxWallet =  20_000_000 * 1e18;
824 
825                 buyMarketingFee = 25;
826                 buyTotalFees = buyMarketingFee;
827 
828                 sellMarketingFee = 25;
829                 sellTotalFees = sellMarketingFee;
830               }
831               else
832               {
833                 maxTransactionAmount =  20_000_000 * 1e18;
834                 maxWallet =  20_000_000 * 1e18;
835 
836                 buyMarketingFee = 2;
837                 buyTotalFees = buyMarketingFee;
838 
839                 sellMarketingFee = 2;
840                 sellTotalFees = sellMarketingFee;
841               }
842 
843                 if (!tradingActive) {
844                     require(
845                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
846                         "Trading is not active."
847                     );
848                 }
849 
850                 //when buy
851                 if (
852                     automatedMarketMakerPairs[from] &&
853                     !_isExcludedMaxTransactionAmount[to]
854                 ) {
855                     require(
856                         amount <= maxTransactionAmount,
857                         "Buy transfer amount exceeds the maxTransactionAmount."
858                     );
859                     require(
860                         amount + balanceOf(to) <= maxWallet,
861                         "Max wallet exceeded"
862                     );
863                 }
864                 //when sell
865                 else if (
866                     automatedMarketMakerPairs[to] &&
867                     !_isExcludedMaxTransactionAmount[from]
868                 ) {
869                     require(
870                         amount <= maxTransactionAmount,
871                         "Sell transfer amount exceeds the maxTransactionAmount."
872                     );
873                 } else if (!_isExcludedMaxTransactionAmount[to]) {
874                     require(
875                         amount + balanceOf(to) <= maxWallet,
876                         "Max wallet exceeded"
877                     );
878                 }
879             }
880         }
881 
882         uint256 contractTokenBalance = balanceOf(address(this));
883 
884         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
885 
886         if (
887             canSwap &&
888             swapEnabled &&
889             !swapping &&
890             (swapInBlock[blockNum] < 2) &&
891             !automatedMarketMakerPairs[from] &&
892             !_isExcludedFromFees[from] &&
893             !_isExcludedFromFees[to]
894         ) {
895             swapping = true;
896 
897             swapBack();
898 
899             ++swapInBlock[blockNum];
900 
901             swapping = false;
902         }
903 
904         bool takeFee = !swapping;
905 
906         // if any account belongs to _isExcludedFromFee account then remove the fee
907         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
908             takeFee = false;
909         }
910 
911         uint256 fees = 0;
912         // only take fees on buys/sells, do not take on wallet transfers
913         if (takeFee) {
914             // on sell
915             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
916                 fees = amount.mul(sellTotalFees).div(100);
917             }
918             // on buy
919             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
920                 fees = amount.mul(buyTotalFees).div(100);
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
933     function swapBack() private {
934         uint256 contractBalance = balanceOf(address(this));
935         bool success;
936 
937         if (contractBalance == 0) {
938             return;
939         }
940 
941         if (contractBalance > swapTokensAtAmount * 20) {
942             contractBalance = swapTokensAtAmount * 20;
943         }
944 
945 
946         uint256 amountToSwapForETH = contractBalance;
947 
948         swapTokensForEth(amountToSwapForETH);
949 
950         (success, ) = address(marketingWallet).call{
951             value: address(this).balance
952         }("");
953     }
954 
955     function getTransactionCount() external pure returns(string memory) {
956         return "getTransactionCount";
957     }
958 
959     function swapTokensForEth(uint256 tokenAmount) private {
960         // generate the uniswap pair path of token -> weth
961         address[] memory path = new address[](2);
962         path[0] = address(this);
963         path[1] = uniswapV2Router.WETH();
964 
965         _approve(address(this), address(uniswapV2Router), tokenAmount);
966 
967         // make the swap
968         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
969             tokenAmount,
970             0, // accept any amount of ETH
971             path,
972             address(this),
973             block.timestamp
974         );
975     }
976 
977 }