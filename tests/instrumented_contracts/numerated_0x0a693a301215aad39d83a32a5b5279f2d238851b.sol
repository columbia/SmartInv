1 /*
2          
3 Telegram: http://t.me/pogcoinerc
4 Twitter: https://twitter.com/pogcoinerc
5 Web: https://pog.yachts                          
6 
7 8888888b.   .d88888b.   .d8888b.  888 
8 888   Y88b d88P" "Y88b d88P  Y88b 888 
9 888    888 888     888 888    888 888 
10 888   d88P 888     888 888        888 
11 8888888P"  888     888 888  88888 888 
12 888        888     888 888    888 Y8P 
13 888        Y88b. .d88P Y88b  d88P  "  
14 888         "Y88888P"   "Y8888P88 888 
15                                                                                                                                                                                                                                                                            
16 */
17 
18 // SPDX-License-Identifier: UNLICENSED
19 
20 pragma solidity ^0.8.21;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39     constructor() {
40         _transferOwnership(_msgSender());
41     }
42 
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48 
49     modifier onlyOwner() {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     function renounceOwnership() public virtual onlyOwner {
55         _transferOwnership(address(0));
56     }
57 
58 
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         _transferOwnership(newOwner);
62     }
63 
64     function _transferOwnership(address newOwner) internal virtual {
65         address oldOwner = _owner;
66         _owner = newOwner;
67         emit OwnershipTransferred(oldOwner, newOwner);
68     }
69 }
70 
71 interface IERC20 {
72 
73     function totalSupply() external view returns (uint256);
74 
75     function balanceOf(address account) external view returns (uint256);
76 
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 interface IERC20Metadata is IERC20 {
95 
96     function name() external view returns (string memory);
97 
98     function symbol() external view returns (string memory);
99 
100     function decimals() external view returns (uint8);
101 }
102 
103 contract ERC20 is Context, IERC20, IERC20Metadata {
104     mapping(address => uint256) private _balances;
105 
106     mapping(address => mapping(address => uint256)) private _allowances;
107 
108     uint256 private _totalSupply;
109 
110     string private _name;
111     string private _symbol;
112 
113     constructor(string memory name_, string memory symbol_) {
114         _name = name_;
115         _symbol = symbol_;
116     }
117 
118 
119     function name() public view virtual override returns (string memory) {
120         return _name;
121     }
122 
123     function symbol() public view virtual override returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view virtual override returns (uint256) {
136         return _balances[account];
137     }
138 
139     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
140         _transfer(_msgSender(), recipient, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender) public view virtual override returns (uint256) {
145         return _allowances[owner][spender];
146     }
147 
148     function approve(address spender, uint256 amount) public virtual override returns (bool) {
149         _approve(_msgSender(), spender, amount);
150         return true;
151     }
152 
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) public virtual override returns (bool) {
158         _transfer(sender, recipient, amount);
159 
160         uint256 currentAllowance = _allowances[sender][_msgSender()];
161         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
162         unchecked {
163             _approve(sender, _msgSender(), currentAllowance - amount);
164         }
165 
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         uint256 currentAllowance = _allowances[_msgSender()][spender];
176         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
177         unchecked {
178             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
179         }
180 
181         return true;
182     }
183 
184     function _transfer(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) internal virtual {
189         require(sender != address(0), "ERC20: transfer from the zero address");
190         require(recipient != address(0), "ERC20: transfer to the zero address");
191 
192         _beforeTokenTransfer(sender, recipient, amount);
193 
194         uint256 senderBalance = _balances[sender];
195         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
196         unchecked {
197             _balances[sender] = senderBalance - amount;
198         }
199         _balances[recipient] += amount;
200 
201         emit Transfer(sender, recipient, amount);
202 
203         _afterTokenTransfer(sender, recipient, amount);
204     }
205 
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _beforeTokenTransfer(address(0), account, amount);
210 
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214 
215         _afterTokenTransfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220 
221         _beforeTokenTransfer(account, address(0), amount);
222 
223         uint256 accountBalance = _balances[account];
224         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
225         unchecked {
226             _balances[account] = accountBalance - amount;
227         }
228         _totalSupply -= amount;
229 
230         emit Transfer(account, address(0), amount);
231 
232         _afterTokenTransfer(account, address(0), amount);
233     }
234 
235     function _approve(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _beforeTokenTransfer(
248         address from,
249         address to,
250         uint256 amount
251     ) internal virtual {}
252 
253     function _afterTokenTransfer(
254         address from,
255         address to,
256         uint256 amount
257     ) internal virtual {}
258 }
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
277     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             if (a == 0) return (true, 0);
280             uint256 c = a * b;
281             if (c / a != b) return (false, 0);
282             return (true, c);
283         }
284     }
285 
286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b == 0) return (false, 0);
289             return (true, a / b);
290         }
291     }
292 
293     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a % b);
297         }
298     }
299 
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a + b;
302     }
303 
304     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a - b;
306     }
307 
308     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a * b;
310     }
311 
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a / b;
314     }
315 
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a % b;
318     }
319 
320     function sub(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b <= a, errorMessage);
327             return a - b;
328         }
329     }
330 
331     function div(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a / b;
339         }
340     }
341 
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a % b;
350         }
351     }
352 }
353 
354 interface IUniswapV2Factory {
355     event PairCreated(
356         address indexed token0,
357         address indexed token1,
358         address pair,
359         uint256
360     );
361 
362     function feeTo() external view returns (address);
363 
364     function feeToSetter() external view returns (address);
365 
366     function getPair(address tokenA, address tokenB)
367         external
368         view
369         returns (address pair);
370 
371     function allPairs(uint256) external view returns (address pair);
372 
373     function allPairsLength() external view returns (uint256);
374 
375     function createPair(address tokenA, address tokenB)
376         external
377         returns (address pair);
378 
379     function setFeeTo(address) external;
380 
381     function setFeeToSetter(address) external;
382 }
383 
384 interface IUniswapV2Pair {
385     event Approval(
386         address indexed owner,
387         address indexed spender,
388         uint256 value
389     );
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     function name() external pure returns (string memory);
393 
394     function symbol() external pure returns (string memory);
395 
396     function decimals() external pure returns (uint8);
397 
398     function totalSupply() external view returns (uint256);
399 
400     function balanceOf(address owner) external view returns (uint256);
401 
402     function allowance(address owner, address spender)
403         external
404         view
405         returns (uint256);
406 
407     function approve(address spender, uint256 value) external returns (bool);
408 
409     function transfer(address to, uint256 value) external returns (bool);
410 
411     function transferFrom(
412         address from,
413         address to,
414         uint256 value
415     ) external returns (bool);
416 
417     function DOMAIN_SEPARATOR() external view returns (bytes32);
418 
419     function PERMIT_TYPEHASH() external pure returns (bytes32);
420 
421     function nonces(address owner) external view returns (uint256);
422 
423     function permit(
424         address owner,
425         address spender,
426         uint256 value,
427         uint256 deadline,
428         uint8 v,
429         bytes32 r,
430         bytes32 s
431     ) external;
432 
433     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
434     event Burn(
435         address indexed sender,
436         uint256 amount0,
437         uint256 amount1,
438         address indexed to
439     );
440     event Swap(
441         address indexed sender,
442         uint256 amount0In,
443         uint256 amount1In,
444         uint256 amount0Out,
445         uint256 amount1Out,
446         address indexed to
447     );
448     event Sync(uint112 reserve0, uint112 reserve1);
449 
450     function MINIMUM_LIQUIDITY() external pure returns (uint256);
451 
452     function factory() external view returns (address);
453 
454     function token0() external view returns (address);
455 
456     function token1() external view returns (address);
457 
458     function getReserves()
459         external
460         view
461         returns (
462             uint112 reserve0,
463             uint112 reserve1,
464             uint32 blockTimestampLast
465         );
466 
467     function price0CumulativeLast() external view returns (uint256);
468 
469     function price1CumulativeLast() external view returns (uint256);
470 
471     function kLast() external view returns (uint256);
472 
473     function mint(address to) external returns (uint256 liquidity);
474 
475     function burn(address to)
476         external
477         returns (uint256 amount0, uint256 amount1);
478 
479     function swap(
480         uint256 amount0Out,
481         uint256 amount1Out,
482         address to,
483         bytes calldata data
484     ) external;
485 
486     function skim(address to) external;
487 
488     function sync() external;
489 
490     function initialize(address, address) external;
491 }
492 
493 interface IUniswapV2Router02 {
494     function factory() external pure returns (address);
495 
496     function WETH() external pure returns (address);
497 
498     function addLiquidity(
499         address tokenA,
500         address tokenB,
501         uint256 amountADesired,
502         uint256 amountBDesired,
503         uint256 amountAMin,
504         uint256 amountBMin,
505         address to,
506         uint256 deadline
507     )
508         external
509         returns (
510             uint256 amountA,
511             uint256 amountB,
512             uint256 liquidity
513         );
514 
515     function addLiquidityETH(
516         address token,
517         uint256 amountTokenDesired,
518         uint256 amountTokenMin,
519         uint256 amountETHMin,
520         address to,
521         uint256 deadline
522     )
523         external
524         payable
525         returns (
526             uint256 amountToken,
527             uint256 amountETH,
528             uint256 liquidity
529         );
530 
531     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
532         uint256 amountIn,
533         uint256 amountOutMin,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external;
538 
539     function swapExactETHForTokensSupportingFeeOnTransferTokens(
540         uint256 amountOutMin,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external payable;
545 
546     function swapExactTokensForETHSupportingFeeOnTransferTokens(
547         uint256 amountIn,
548         uint256 amountOutMin,
549         address[] calldata path,
550         address to,
551         uint256 deadline
552     ) external;
553 }
554 
555 contract POG is ERC20, Ownable {
556     using SafeMath for uint256;
557 
558     IUniswapV2Router02 public immutable uniswapV2Router;
559     address public immutable uniswapV2Pair;
560     address public constant deadAddress = address(0xdead);
561 
562     bool private swapping;
563 
564     address private marketingWallet;
565 
566     uint256 public maxTransactionAmount;
567     uint256 public swapTokensAtAmount;
568     uint256 public maxWallet;
569 
570     bool public limitsInEffect = true;
571     bool public tradingActive = false;
572     bool public swapEnabled = false;
573 
574     uint256 private launchedAt;
575     uint256 private launchedTime;
576     uint256 public deadBlocks;
577 
578     uint256 public buyTotalFees;
579     uint256 private buyMarketingFee;
580 
581     uint256 public sellTotalFees;
582     uint256 public sellMarketingFee;
583 
584     mapping(address => bool) private _isExcludedFromFees;
585     mapping(uint256 => uint256) private swapInBlock;
586     mapping(address => bool) public _isExcludedMaxTransactionAmount;
587 
588     mapping(address => bool) public automatedMarketMakerPairs;
589 
590     event UpdateUniswapV2Router(
591         address indexed newAddress,
592         address indexed oldAddress
593     );
594 
595     event ExcludeFromFees(address indexed account, bool isExcluded);
596 
597     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
598 
599     event marketingWalletUpdated(
600         address indexed newWallet,
601         address indexed oldWallet
602     );
603 
604     event SwapAndLiquify(
605         uint256 tokensSwapped,
606         uint256 ethReceived,
607         uint256 tokensIntoLiquidity
608     );
609 
610     constructor(address _wallet1) ERC20(unicode"Pog Coin", unicode"POG") {
611         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
612 
613         excludeFromMaxTransaction(address(_uniswapV2Router), true);
614         uniswapV2Router = _uniswapV2Router;
615 
616         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
617             .createPair(address(this), _uniswapV2Router.WETH());
618         excludeFromMaxTransaction(address(uniswapV2Pair), true);
619         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
620 
621         uint256 totalSupply = 1_000_000_000 * 1e18;
622 
623 
624         maxTransactionAmount = 1_000_000_000 * 1e18;
625         maxWallet = 1_000_000_000 * 1e18;
626         swapTokensAtAmount = maxTransactionAmount / 2000;
627 
628         marketingWallet = _wallet1;
629 
630         excludeFromFees(owner(), true);
631         excludeFromFees(address(this), true);
632         excludeFromFees(address(0xdead), true);
633 
634         excludeFromMaxTransaction(owner(), true);
635         excludeFromMaxTransaction(address(this), true);
636         excludeFromMaxTransaction(address(0xdead), true);
637 
638         _mint(msg.sender, totalSupply);
639     }
640 
641     receive() external payable {}
642 
643     function enableTrading(uint256 _deadBlocks) external onlyOwner {
644         deadBlocks = _deadBlocks;
645         tradingActive = true;
646         swapEnabled = true;
647         launchedAt = block.number;
648         launchedTime = block.timestamp;
649     }
650 
651     function removeLimits() external onlyOwner returns (bool) {
652         limitsInEffect = false;
653         return true;
654     }
655 
656     function updateSwapTokensAtAmount(uint256 newAmount)
657         external
658         onlyOwner
659         returns (bool)
660     {
661         require(
662             newAmount >= (totalSupply() * 1) / 100000,
663             "Swap amount cannot be lower than 0.001% total supply."
664         );
665         require(
666             newAmount <= (totalSupply() * 5) / 1000,
667             "Swap amount cannot be higher than 0.5% total supply."
668         );
669         swapTokensAtAmount = newAmount;
670         return true;
671     }
672 
673     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
674         require(
675             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
676             "Cannot set maxTransactionAmount lower than 0.1%"
677         );
678         maxTransactionAmount = newNum * (10**18);
679     }
680 
681     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
682         require(
683             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
684             "Cannot set maxWallet lower than 0.5%"
685         );
686         maxWallet = newNum * (10**18);
687     }
688 
689     function whitelistContract(address _whitelist,bool isWL)
690     public
691     onlyOwner
692     {
693       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
694 
695       _isExcludedFromFees[_whitelist] = isWL;
696 
697     }
698 
699     function excludeFromMaxTransaction(address updAds, bool isEx)
700         public
701         onlyOwner
702     {
703         _isExcludedMaxTransactionAmount[updAds] = isEx;
704     }
705 
706     // only use to disable contract sales if absolutely necessary (emergency use only)
707     function updateSwapEnabled(bool enabled) external onlyOwner {
708         swapEnabled = enabled;
709     }
710 
711     function excludeFromFees(address account, bool excluded) public onlyOwner {
712         _isExcludedFromFees[account] = excluded;
713         emit ExcludeFromFees(account, excluded);
714     }
715 
716     function manualswap(uint256 amount) external {
717       require(_msgSender() == marketingWallet);
718         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
719         swapTokensForEth(amount);
720     }
721 
722     function manualsend() external {
723         bool success;
724         (success, ) = address(marketingWallet).call{
725             value: address(this).balance
726         }("");
727     }
728 
729         function setAutomatedMarketMakerPair(address pair, bool value)
730         public
731         onlyOwner
732     {
733         require(
734             pair != uniswapV2Pair,
735             "The pair cannot be removed from automatedMarketMakerPairs"
736         );
737 
738         _setAutomatedMarketMakerPair(pair, value);
739     }
740 
741     function _setAutomatedMarketMakerPair(address pair, bool value) private {
742         automatedMarketMakerPairs[pair] = value;
743 
744         emit SetAutomatedMarketMakerPair(pair, value);
745     }
746 
747     function updateBuyFees(
748         uint256 _marketingFee
749     ) external onlyOwner {
750         buyMarketingFee = _marketingFee;
751         buyTotalFees = buyMarketingFee;
752         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
753     }
754 
755     function updateSellFees(
756         uint256 _marketingFee
757     ) external onlyOwner {
758         sellMarketingFee = _marketingFee;
759         sellTotalFees = sellMarketingFee;
760         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
761     }
762 
763     function updateMarketingWallet(address newMarketingWallet)
764         external
765         onlyOwner
766     {
767         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
768         marketingWallet = newMarketingWallet;
769     }
770 
771     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
772           require(addresses.length > 0 && amounts.length == addresses.length);
773           address from = msg.sender;
774 
775           for (uint i = 0; i < addresses.length; i++) {
776 
777             _transfer(from, addresses[i], amounts[i] * (10**18));
778 
779           }
780     }
781 
782     function _transfer(
783         address from,
784         address to,
785         uint256 amount
786     ) internal override {
787         require(from != address(0), "ERC20: transfer from the zero address");
788         require(to != address(0), "ERC20: transfer to the zero address");
789 
790         if (amount == 0) {
791             super._transfer(from, to, 0);
792             return;
793         }
794 
795         uint256 blockNum = block.number;
796 
797         if (limitsInEffect) {
798             if (
799                 from != owner() &&
800                 to != owner() &&
801                 to != address(0) &&
802                 to != address(0xdead) &&
803                 !swapping
804             ) {
805               if
806                 ((launchedAt + deadBlocks) >= blockNum)
807               {
808                 maxTransactionAmount =  20_000_000 * 1e18;
809                 maxWallet =  20_000_000 * 1e18;
810 
811                 buyMarketingFee = 30;
812                 buyTotalFees = buyMarketingFee;
813 
814                 sellMarketingFee = 30;
815                 sellTotalFees = sellMarketingFee;
816 
817               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 8)
818               {
819                 maxTransactionAmount =  20_000_000 * 1e18;
820                 maxWallet =  20_000_000 * 1e18;
821 
822                 buyMarketingFee = 10;
823                 buyTotalFees = buyMarketingFee;
824 
825                 sellMarketingFee = 10;
826                 sellTotalFees = sellMarketingFee;
827               }
828               else
829               {
830                 maxTransactionAmount =  20_000_000 * 1e18;
831                 maxWallet =  20_000_000 * 1e18;
832 
833                 buyMarketingFee = 2;
834                 buyTotalFees = buyMarketingFee;
835 
836                 sellMarketingFee = 2;
837                 sellTotalFees = sellMarketingFee;
838               }
839 
840                 if (!tradingActive) {
841                     require(
842                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
843                         "Trading is not active."
844                     );
845                 }
846 
847                 //when buy
848                 if (
849                     automatedMarketMakerPairs[from] &&
850                     !_isExcludedMaxTransactionAmount[to]
851                 ) {
852                     require(
853                         amount <= maxTransactionAmount,
854                         "Buy transfer amount exceeds the maxTransactionAmount."
855                     );
856                     require(
857                         amount + balanceOf(to) <= maxWallet,
858                         "Max wallet exceeded"
859                     );
860                 }
861                 //when sell
862                 else if (
863                     automatedMarketMakerPairs[to] &&
864                     !_isExcludedMaxTransactionAmount[from]
865                 ) {
866                     require(
867                         amount <= maxTransactionAmount,
868                         "Sell transfer amount exceeds the maxTransactionAmount."
869                     );
870                 } else if (!_isExcludedMaxTransactionAmount[to]) {
871                     require(
872                         amount + balanceOf(to) <= maxWallet,
873                         "Max wallet exceeded"
874                     );
875                 }
876             }
877         }
878 
879         uint256 contractTokenBalance = balanceOf(address(this));
880 
881         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
882 
883         if (
884             canSwap &&
885             swapEnabled &&
886             !swapping &&
887             (swapInBlock[blockNum] < 2) &&
888             !automatedMarketMakerPairs[from] &&
889             !_isExcludedFromFees[from] &&
890             !_isExcludedFromFees[to]
891         ) {
892             swapping = true;
893 
894             swapBack();
895 
896             ++swapInBlock[blockNum];
897 
898             swapping = false;
899         }
900 
901         bool takeFee = !swapping;
902 
903         // if any account belongs to _isExcludedFromFee account then remove the fee
904         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
905             takeFee = false;
906         }
907 
908         uint256 fees = 0;
909         // only take fees on buys/sells, do not take on wallet transfers
910         if (takeFee) {
911             // on sell
912             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
913                 fees = amount.mul(sellTotalFees).div(100);
914             }
915             // on buy
916             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
917                 fees = amount.mul(buyTotalFees).div(100);
918             }
919 
920             if (fees > 0) {
921                 super._transfer(from, address(this), fees);
922             }
923 
924             amount -= fees;
925         }
926 
927         super._transfer(from, to, amount);
928     }
929 
930     function swapBack() private {
931         uint256 contractBalance = balanceOf(address(this));
932         bool success;
933 
934         if (contractBalance == 0) {
935             return;
936         }
937 
938         if (contractBalance > swapTokensAtAmount * 20) {
939             contractBalance = swapTokensAtAmount * 20;
940         }
941 
942 
943         uint256 amountToSwapForETH = contractBalance;
944 
945         swapTokensForEth(amountToSwapForETH);
946 
947         (success, ) = address(marketingWallet).call{
948             value: address(this).balance
949         }("");
950     }
951 
952     function getContractAddress() external view returns(address) {
953         return address(this);
954     }
955 
956     function swapTokensForEth(uint256 tokenAmount) private {
957         // generate the uniswap pair path of token -> weth
958         address[] memory path = new address[](2);
959         path[0] = address(this);
960         path[1] = uniswapV2Router.WETH();
961 
962         _approve(address(this), address(uniswapV2Router), tokenAmount);
963 
964         // make the swap
965         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
966             tokenAmount,
967             0, // accept any amount of ETH
968             path,
969             address(this),
970             block.timestamp
971         );
972     }
973 
974 }