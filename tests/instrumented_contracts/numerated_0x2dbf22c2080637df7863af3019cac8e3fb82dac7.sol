1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 $$$$$$$\   $$$$$$\   $$$$$$\
6 $$  __$$\ $$  __$$\ $$  __$$\
7 $$ |  $$ |$$ /  $$ |$$ /  \__|
8 $$$$$$$  |$$ |  $$ |$$ |$$$$\
9 $$  __$$< $$ |  $$ |$$ |\_$$ |
10 $$ |  $$ |$$ |  $$ |$$ |  $$ |
11 $$ |  $$ | $$$$$$  |\$$$$$$  |
12 \__|  \__| \______/  \______/
13 
14 The only rule of $ROG is to ROG out with your glock out
15 
16 https://rog.mom
17 http://t.me/tickerROG
18 https://twitter.com/tickerROG
19 
20 */
21 
22 pragma solidity ^0.8.21;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41     constructor() {
42         _transferOwnership(_msgSender());
43     }
44 
45 
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60 
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _transferOwnership(newOwner);
64     }
65 
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 interface IERC20 {
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address account) external view returns (uint256);
78 
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97 
98     function name() external view returns (string memory);
99 
100     function symbol() external view returns (string memory);
101 
102     function decimals() external view returns (uint8);
103 }
104 
105 contract ERC20 is Context, IERC20, IERC20Metadata {
106     mapping(address => uint256) private _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114 
115     constructor(string memory name_, string memory symbol_) {
116         _name = name_;
117         _symbol = symbol_;
118     }
119 
120 
121     function name() public view virtual override returns (string memory) {
122         return _name;
123     }
124 
125     function symbol() public view virtual override returns (string memory) {
126         return _symbol;
127     }
128 
129     function decimals() public view virtual override returns (uint8) {
130         return 9;
131     }
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
146     function allowance(address owner, address spender) public view virtual override returns (uint256) {
147         return _allowances[owner][spender];
148     }
149 
150     function approve(address spender, uint256 amount) public virtual override returns (bool) {
151         _approve(_msgSender(), spender, amount);
152         return true;
153     }
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         _transfer(sender, recipient, amount);
161 
162         uint256 currentAllowance = _allowances[sender][_msgSender()];
163         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
164         unchecked {
165             _approve(sender, _msgSender(), currentAllowance - amount);
166         }
167 
168         return true;
169     }
170 
171     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
172         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
177         uint256 currentAllowance = _allowances[_msgSender()][spender];
178         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
179         unchecked {
180             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
181         }
182 
183         return true;
184     }
185 
186     function _transfer(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) internal virtual {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         _beforeTokenTransfer(sender, recipient, amount);
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204 
205         _afterTokenTransfer(sender, recipient, amount);
206     }
207 
208     function _mint(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: mint to the zero address");
210 
211         _beforeTokenTransfer(address(0), account, amount);
212 
213         _totalSupply += amount;
214         _balances[account] += amount;
215         emit Transfer(address(0), account, amount);
216 
217         _afterTokenTransfer(address(0), account, amount);
218     }
219 
220     function _burn(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: burn from the zero address");
222 
223         _beforeTokenTransfer(account, address(0), amount);
224 
225         uint256 accountBalance = _balances[account];
226         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
227         unchecked {
228             _balances[account] = accountBalance - amount;
229         }
230         _totalSupply -= amount;
231 
232         emit Transfer(account, address(0), amount);
233 
234         _afterTokenTransfer(account, address(0), amount);
235     }
236 
237     function _approve(
238         address owner,
239         address spender,
240         uint256 amount
241     ) internal virtual {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244 
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 
249     function _beforeTokenTransfer(
250         address from,
251         address to,
252         uint256 amount
253     ) internal virtual {}
254 
255     function _afterTokenTransfer(
256         address from,
257         address to,
258         uint256 amount
259     ) internal virtual {}
260 }
261 
262 library SafeMath {
263 
264     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             uint256 c = a + b;
267             if (c < a) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b > a) return (false, 0);
275             return (true, a - b);
276         }
277     }
278 
279     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (a == 0) return (true, 0);
282             uint256 c = a * b;
283             if (c / a != b) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b == 0) return (false, 0);
291             return (true, a / b);
292         }
293     }
294 
295     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             if (b == 0) return (false, 0);
298             return (true, a % b);
299         }
300     }
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
344     function mod(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         unchecked {
350             require(b > 0, errorMessage);
351             return a % b;
352         }
353     }
354 }
355 
356 interface IUniswapV2Factory {
357     event PairCreated(
358         address indexed token0,
359         address indexed token1,
360         address pair,
361         uint256
362     );
363 
364     function feeTo() external view returns (address);
365 
366     function feeToSetter() external view returns (address);
367 
368     function getPair(address tokenA, address tokenB)
369         external
370         view
371         returns (address pair);
372 
373     function allPairs(uint256) external view returns (address pair);
374 
375     function allPairsLength() external view returns (uint256);
376 
377     function createPair(address tokenA, address tokenB)
378         external
379         returns (address pair);
380 
381     function setFeeTo(address) external;
382 
383     function setFeeToSetter(address) external;
384 }
385 
386 interface IUniswapV2Pair {
387     event Approval(
388         address indexed owner,
389         address indexed spender,
390         uint256 value
391     );
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     function name() external pure returns (string memory);
395 
396     function symbol() external pure returns (string memory);
397 
398     function decimals() external pure returns (uint8);
399 
400     function totalSupply() external view returns (uint256);
401 
402     function balanceOf(address owner) external view returns (uint256);
403 
404     function allowance(address owner, address spender)
405         external
406         view
407         returns (uint256);
408 
409     function approve(address spender, uint256 value) external returns (bool);
410 
411     function transfer(address to, uint256 value) external returns (bool);
412 
413     function transferFrom(
414         address from,
415         address to,
416         uint256 value
417     ) external returns (bool);
418 
419     function DOMAIN_SEPARATOR() external view returns (bytes32);
420 
421     function PERMIT_TYPEHASH() external pure returns (bytes32);
422 
423     function nonces(address owner) external view returns (uint256);
424 
425     function permit(
426         address owner,
427         address spender,
428         uint256 value,
429         uint256 deadline,
430         uint8 v,
431         bytes32 r,
432         bytes32 s
433     ) external;
434 
435     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
436     event Burn(
437         address indexed sender,
438         uint256 amount0,
439         uint256 amount1,
440         address indexed to
441     );
442     event Swap(
443         address indexed sender,
444         uint256 amount0In,
445         uint256 amount1In,
446         uint256 amount0Out,
447         uint256 amount1Out,
448         address indexed to
449     );
450     event Sync(uint112 reserve0, uint112 reserve1);
451 
452     function MINIMUM_LIQUIDITY() external pure returns (uint256);
453 
454     function factory() external view returns (address);
455 
456     function token0() external view returns (address);
457 
458     function token1() external view returns (address);
459 
460     function getReserves()
461         external
462         view
463         returns (
464             uint112 reserve0,
465             uint112 reserve1,
466             uint32 blockTimestampLast
467         );
468 
469     function price0CumulativeLast() external view returns (uint256);
470 
471     function price1CumulativeLast() external view returns (uint256);
472 
473     function kLast() external view returns (uint256);
474 
475     function mint(address to) external returns (uint256 liquidity);
476 
477     function burn(address to)
478         external
479         returns (uint256 amount0, uint256 amount1);
480 
481     function swap(
482         uint256 amount0Out,
483         uint256 amount1Out,
484         address to,
485         bytes calldata data
486     ) external;
487 
488     function skim(address to) external;
489 
490     function sync() external;
491 
492     function initialize(address, address) external;
493 }
494 
495 interface IUniswapV2Router02 {
496     function factory() external pure returns (address);
497 
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint256 amountADesired,
504         uint256 amountBDesired,
505         uint256 amountAMin,
506         uint256 amountBMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         returns (
512             uint256 amountA,
513             uint256 amountB,
514             uint256 liquidity
515         );
516 
517     function addLiquidityETH(
518         address token,
519         uint256 amountTokenDesired,
520         uint256 amountTokenMin,
521         uint256 amountETHMin,
522         address to,
523         uint256 deadline
524     )
525         external
526         payable
527         returns (
528             uint256 amountToken,
529             uint256 amountETH,
530             uint256 liquidity
531         );
532 
533     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 
541     function swapExactETHForTokensSupportingFeeOnTransferTokens(
542         uint256 amountOutMin,
543         address[] calldata path,
544         address to,
545         uint256 deadline
546     ) external payable;
547 
548     function swapExactTokensForETHSupportingFeeOnTransferTokens(
549         uint256 amountIn,
550         uint256 amountOutMin,
551         address[] calldata path,
552         address to,
553         uint256 deadline
554     ) external;
555 }
556 
557 contract ROG is ERC20, Ownable {
558     using SafeMath for uint256;
559 
560     IUniswapV2Router02 public immutable uniswapV2Router;
561     address public immutable uniswapV2Pair;
562     address public constant deadAddress = address(0xdead);
563 
564     bool private swapping;
565 
566     address public marketingWallet;
567 
568     uint256 public maxTransactionAmount;
569     uint256 public swapTokensAtAmount;
570     uint256 public maxWallet;
571 
572     bool public limitsInEffect = true;
573     bool public tradingActive = false;
574     bool public swapEnabled = false;
575 
576     uint256 private launchedAt;
577     uint256 private launchedTime;
578     uint256 public deadBlocks;
579 
580     uint256 public buyTotalFees;
581     uint256 private buyMarketingFee;
582 
583     uint256 public sellTotalFees;
584     uint256 public sellMarketingFee;
585 
586     uint256 public tokensForMarketing;
587 
588     mapping(address => bool) private _isExcludedFromFees;
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
613     constructor(address _wallet1) ERC20("ROG coin", "ROG") {
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
624         uint256 totalSupply = 420_000_000_000_000 * 1e9;
625 
626 
627         maxTransactionAmount = 420_000_000_000_000 * 1e9;
628         maxWallet = 420_000_000_000_000 * 1e9;
629         swapTokensAtAmount = maxTransactionAmount / 20000;
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
678             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
679             "Cannot set maxTransactionAmount lower than 0.1%"
680         );
681         maxTransactionAmount = newNum * (10**9);
682     }
683 
684     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
685         require(
686             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
687             "Cannot set maxWallet lower than 0.5%"
688         );
689         maxWallet = newNum * (10**9);
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
755         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
756     }
757 
758     function updateSellFees(
759         uint256 _marketingFee
760     ) external onlyOwner {
761         sellMarketingFee = _marketingFee;
762         sellTotalFees = sellMarketingFee;
763         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
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
774     function _transfer(
775         address from,
776         address to,
777         uint256 amount
778     ) internal override {
779         require(from != address(0), "ERC20: transfer from the zero address");
780         require(to != address(0), "ERC20: transfer to the zero address");
781 
782         if (amount == 0) {
783             super._transfer(from, to, 0);
784             return;
785         }
786 
787         if (limitsInEffect) {
788             if (
789                 from != owner() &&
790                 to != owner() &&
791                 to != address(0) &&
792                 to != address(0xdead) &&
793                 !swapping
794             ) {
795               if
796                 ((launchedAt + deadBlocks) >= block.number)
797               {
798                 buyMarketingFee = 99;
799                 buyTotalFees = buyMarketingFee;
800 
801                 sellMarketingFee = 99;
802                 sellTotalFees = sellMarketingFee;
803 
804               } else if(block.number > (launchedAt + deadBlocks) && block.number <= launchedAt + 30)
805               {
806                 maxTransactionAmount =  8_400_000_000_000  * 1e9;
807                 maxTransactionAmount =  8_400_000_000_000  * 1e9;
808 
809                 buyMarketingFee = 30;
810                 buyTotalFees = buyMarketingFee;
811 
812                 sellMarketingFee = 30;
813                 sellTotalFees = sellMarketingFee;
814               }
815 
816                 if (!tradingActive) {
817                     require(
818                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
819                         "Trading is not active."
820                     );
821                 }
822 
823                 //when buy
824                 if (
825                     automatedMarketMakerPairs[from] &&
826                     !_isExcludedMaxTransactionAmount[to]
827                 ) {
828                     require(
829                         amount <= maxTransactionAmount,
830                         "Buy transfer amount exceeds the maxTransactionAmount."
831                     );
832                     require(
833                         amount + balanceOf(to) <= maxWallet,
834                         "Max wallet exceeded"
835                     );
836                 }
837                 //when sell
838                 else if (
839                     automatedMarketMakerPairs[to] &&
840                     !_isExcludedMaxTransactionAmount[from]
841                 ) {
842                     require(
843                         amount <= maxTransactionAmount,
844                         "Sell transfer amount exceeds the maxTransactionAmount."
845                     );
846                 } else if (!_isExcludedMaxTransactionAmount[to]) {
847                     require(
848                         amount + balanceOf(to) <= maxWallet,
849                         "Max wallet exceeded"
850                     );
851                 }
852             }
853         }
854 
855 
856 
857         uint256 contractTokenBalance = balanceOf(address(this));
858 
859         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
860 
861         if (
862             canSwap &&
863             swapEnabled &&
864             !swapping &&
865             !automatedMarketMakerPairs[from] &&
866             !_isExcludedFromFees[from] &&
867             !_isExcludedFromFees[to]
868         ) {
869             swapping = true;
870 
871             swapBack();
872 
873             swapping = false;
874         }
875 
876         bool takeFee = !swapping;
877 
878         // if any account belongs to _isExcludedFromFee account then remove the fee
879         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
880             takeFee = false;
881         }
882 
883         uint256 fees = 0;
884         // only take fees on buys/sells, do not take on wallet transfers
885         if (takeFee) {
886             // on sell
887             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
888                 fees = amount.mul(sellTotalFees).div(100);
889                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
890             }
891             // on buy
892             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
893                 fees = amount.mul(buyTotalFees).div(100);
894                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
895             }
896 
897             if (fees > 0) {
898                 super._transfer(from, address(this), fees);
899             }
900 
901             amount -= fees;
902         }
903 
904         super._transfer(from, to, amount);
905     }
906 
907     function swapTokensForEth(uint256 tokenAmount) private {
908         // generate the uniswap pair path of token -> weth
909         address[] memory path = new address[](2);
910         path[0] = address(this);
911         path[1] = uniswapV2Router.WETH();
912 
913         _approve(address(this), address(uniswapV2Router), tokenAmount);
914 
915         // make the swap
916         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
917             tokenAmount,
918             0, // accept any amount of ETH
919             path,
920             address(this),
921             block.timestamp
922         );
923     }
924 
925 
926     function swapBack() private {
927         uint256 contractBalance = balanceOf(address(this));
928         uint256 totalTokensToSwap =
929             tokensForMarketing;
930         bool success;
931 
932         if (contractBalance == 0 || totalTokensToSwap == 0) {
933             return;
934         }
935 
936         if (contractBalance > swapTokensAtAmount * 20) {
937             contractBalance = swapTokensAtAmount * 20;
938         }
939 
940         // Halve the amount of liquidity tokens
941 
942         uint256 amountToSwapForETH = contractBalance;
943 
944         swapTokensForEth(amountToSwapForETH);
945 
946         tokensForMarketing = 0;
947 
948 
949         (success, ) = address(marketingWallet).call{
950             value: address(this).balance
951         }("");
952     }
953 
954 }