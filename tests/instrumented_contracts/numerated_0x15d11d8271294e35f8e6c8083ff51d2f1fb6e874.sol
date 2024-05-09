1 // https://t.me/pegasuschain_erc
2 // https://pegasuschain.net
3 // https://twitter.com/Pegasuschain
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC20 {
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
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
107     constructor(string memory name_, string memory symbol_) {
108         _name = name_;
109         _symbol = symbol_;
110     }
111 
112 
113     function name() public view virtual override returns (string memory) {
114         return _name;
115     }
116 
117 
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121 
122 
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127 
128     function totalSupply() public view virtual override returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view virtual override returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(_msgSender(), recipient, amount);
138         return true;
139     }
140 
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) public virtual override returns (bool) {
156         _transfer(sender, recipient, amount);
157 
158         uint256 currentAllowance = _allowances[sender][_msgSender()];
159         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
160         unchecked {
161             _approve(sender, _msgSender(), currentAllowance - amount);
162         }
163 
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         uint256 currentAllowance = _allowances[_msgSender()][spender];
174         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
175         unchecked {
176             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
177         }
178 
179         return true;
180     }
181 
182     function _transfer(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) internal virtual {
187         require(sender != address(0), "ERC20: transfer from the zero address");
188         require(recipient != address(0), "ERC20: transfer to the zero address");
189 
190         _beforeTokenTransfer(sender, recipient, amount);
191 
192         uint256 senderBalance = _balances[sender];
193         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
194         unchecked {
195             _balances[sender] = senderBalance - amount;
196         }
197         _balances[recipient] += amount;
198 
199         emit Transfer(sender, recipient, amount);
200 
201         _afterTokenTransfer(sender, recipient, amount);
202     }
203 
204     function _mint(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206 
207         _beforeTokenTransfer(address(0), account, amount);
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212 
213         _afterTokenTransfer(address(0), account, amount);
214     }
215 
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218 
219         _beforeTokenTransfer(account, address(0), amount);
220 
221         uint256 accountBalance = _balances[account];
222         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
223         unchecked {
224             _balances[account] = accountBalance - amount;
225         }
226         _totalSupply -= amount;
227 
228         emit Transfer(account, address(0), amount);
229 
230         _afterTokenTransfer(account, address(0), amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _beforeTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 
251     function _afterTokenTransfer(
252         address from,
253         address to,
254         uint256 amount
255     ) internal virtual {}
256 }
257 
258 
259 library SafeMath {
260 
261     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             uint256 c = a + b;
264             if (c < a) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b > a) return (false, 0);
272             return (true, a - b);
273         }
274     }
275 
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
387 
388 interface IUniswapV2Pair {
389     event Approval(
390         address indexed owner,
391         address indexed spender,
392         uint256 value
393     );
394     event Transfer(address indexed from, address indexed to, uint256 value);
395 
396     function name() external pure returns (string memory);
397 
398     function symbol() external pure returns (string memory);
399 
400     function decimals() external pure returns (uint8);
401 
402     function totalSupply() external view returns (uint256);
403 
404     function balanceOf(address owner) external view returns (uint256);
405 
406     function allowance(address owner, address spender)
407         external
408         view
409         returns (uint256);
410 
411     function approve(address spender, uint256 value) external returns (bool);
412 
413     function transfer(address to, uint256 value) external returns (bool);
414 
415     function transferFrom(
416         address from,
417         address to,
418         uint256 value
419     ) external returns (bool);
420 
421     function DOMAIN_SEPARATOR() external view returns (bytes32);
422 
423     function PERMIT_TYPEHASH() external pure returns (bytes32);
424 
425     function nonces(address owner) external view returns (uint256);
426 
427     function permit(
428         address owner,
429         address spender,
430         uint256 value,
431         uint256 deadline,
432         uint8 v,
433         bytes32 r,
434         bytes32 s
435     ) external;
436 
437     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
438     event Burn(
439         address indexed sender,
440         uint256 amount0,
441         uint256 amount1,
442         address indexed to
443     );
444     event Swap(
445         address indexed sender,
446         uint256 amount0In,
447         uint256 amount1In,
448         uint256 amount0Out,
449         uint256 amount1Out,
450         address indexed to
451     );
452     event Sync(uint112 reserve0, uint112 reserve1);
453 
454     function MINIMUM_LIQUIDITY() external pure returns (uint256);
455 
456     function factory() external view returns (address);
457 
458     function token0() external view returns (address);
459 
460     function token1() external view returns (address);
461 
462     function getReserves()
463         external
464         view
465         returns (
466             uint112 reserve0,
467             uint112 reserve1,
468             uint32 blockTimestampLast
469         );
470 
471     function price0CumulativeLast() external view returns (uint256);
472 
473     function price1CumulativeLast() external view returns (uint256);
474 
475     function kLast() external view returns (uint256);
476 
477     function mint(address to) external returns (uint256 liquidity);
478 
479     function burn(address to)
480         external
481         returns (uint256 amount0, uint256 amount1);
482 
483     function swap(
484         uint256 amount0Out,
485         uint256 amount1Out,
486         address to,
487         bytes calldata data
488     ) external;
489 
490     function skim(address to) external;
491 
492     function sync() external;
493 
494     function initialize(address, address) external;
495 }
496 
497 
498 interface IUniswapV2Router02 {
499     function factory() external pure returns (address);
500 
501     function WETH() external pure returns (address);
502 
503     function addLiquidity(
504         address tokenA,
505         address tokenB,
506         uint256 amountADesired,
507         uint256 amountBDesired,
508         uint256 amountAMin,
509         uint256 amountBMin,
510         address to,
511         uint256 deadline
512     )
513         external
514         returns (
515             uint256 amountA,
516             uint256 amountB,
517             uint256 liquidity
518         );
519 
520     function addLiquidityETH(
521         address token,
522         uint256 amountTokenDesired,
523         uint256 amountTokenMin,
524         uint256 amountETHMin,
525         address to,
526         uint256 deadline
527     )
528         external
529         payable
530         returns (
531             uint256 amountToken,
532             uint256 amountETH,
533             uint256 liquidity
534         );
535 
536     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
537         uint256 amountIn,
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external;
543 
544     function swapExactETHForTokensSupportingFeeOnTransferTokens(
545         uint256 amountOutMin,
546         address[] calldata path,
547         address to,
548         uint256 deadline
549     ) external payable;
550 
551     function swapExactTokensForETHSupportingFeeOnTransferTokens(
552         uint256 amountIn,
553         uint256 amountOutMin,
554         address[] calldata path,
555         address to,
556         uint256 deadline
557     ) external;
558 }
559 
560 
561 contract Pegasus is ERC20, Ownable {
562     using SafeMath for uint256;
563 
564     IUniswapV2Router02 public immutable uniswapV2Router;
565     address public immutable uniswapV2Pair;
566     address public constant deadAddress = address(0xdead);
567 
568     bool private swapping;
569 
570     address public marketingWallet;
571     address public devWallet;
572 
573     uint256 public maxTransactionAmount;
574     uint256 public swapTokensAtAmount;
575     uint256 public maxWallet;
576 
577     uint256 public percentForLPBurn = 0; 
578     bool public lpBurnEnabled = false;
579     uint256 public lpBurnFrequency = 3600 seconds;
580     uint256 public lastLpBurnTime;
581 
582     uint256 public manualBurnFrequency = 30 minutes;
583     uint256 public lastManualLpBurnTime;
584 
585     bool public limitsInEffect = true;
586     bool public tradingActive = false;
587     bool public swapEnabled = true;
588 
589     mapping(address => uint256) private _holderLastTransferTimestamp; 
590     bool public transferDelayEnabled = true;
591 
592     uint256 public buyTotalFees;
593     uint256 public buyMarketingFee;
594     uint256 public buyLiquidityFee;
595     uint256 public buyDevFee;
596 
597     uint256 public sellTotalFees;
598     uint256 public sellMarketingFee;
599     uint256 public sellLiquidityFee;
600     uint256 public sellDevFee;
601 
602     uint256 public tokensForMarketing;
603     uint256 public tokensForLiquidity;
604     uint256 public tokensForDev;
605 
606     mapping(address => bool) private _isExcludedFromFees;
607     mapping(address => bool) public _isExcludedMaxTransactionAmount;
608 
609     mapping(address => bool) public automatedMarketMakerPairs;
610 
611     event UpdateUniswapV2Router(
612         address indexed newAddress,
613         address indexed oldAddress
614     );
615 
616     event ExcludeFromFees(address indexed account, bool isExcluded);
617 
618     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
619 
620     event marketingWalletUpdated(
621         address indexed newWallet,
622         address indexed oldWallet
623     );
624 
625     event devWalletUpdated(
626         address indexed newWallet,
627         address indexed oldWallet
628     );
629 
630     event SwapAndLiquify(
631         uint256 tokensSwapped,
632         uint256 ethReceived,
633         uint256 tokensIntoLiquidity
634     );
635 
636     event AutoNukeLP();
637 
638     event ManualNukeLP();
639 
640     constructor() ERC20("Pegasus Chain", "PEG") {
641         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
642             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
643         );
644 
645         excludeFromMaxTransaction(address(_uniswapV2Router), true);
646         uniswapV2Router = _uniswapV2Router;
647 
648         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
649             .createPair(address(this), _uniswapV2Router.WETH());
650         excludeFromMaxTransaction(address(uniswapV2Pair), true);
651         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
652 
653         uint256 _buyMarketingFee = 8;
654         uint256 _buyLiquidityFee = 0;
655         uint256 _buyDevFee = 2;
656 
657         uint256 _sellMarketingFee = 72;
658         uint256 _sellLiquidityFee = 0;
659         uint256 _sellDevFee = 18;
660 
661         uint256 totalSupply = 1_000_000_000 * 1e18;
662 
663         maxTransactionAmount = 15_000_000 * 1e18; 
664         maxWallet = 20_000_000 * 1e18; 
665         swapTokensAtAmount = (totalSupply * 5) / 10000;
666 
667         buyMarketingFee = _buyMarketingFee;
668         buyLiquidityFee = _buyLiquidityFee;
669         buyDevFee = _buyDevFee;
670         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
671 
672         sellMarketingFee = _sellMarketingFee;
673         sellLiquidityFee = _sellLiquidityFee;
674         sellDevFee = _sellDevFee;
675         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
676 
677         marketingWallet = address(0x7a26737b28Cd7b2C13077e1a13118CfB8e61e00f); 
678         devWallet = address(0xff15A5C8Be280d587685Ad7d413d0fCe4AABbd8b); 
679 
680         // exclude from paying fees or having max transaction amount
681         excludeFromFees(owner(), true);
682         excludeFromFees(address(this), true);
683         excludeFromFees(address(0xdead), true);
684 
685         excludeFromMaxTransaction(owner(), true);
686         excludeFromMaxTransaction(address(this), true);
687         excludeFromMaxTransaction(address(0xdead), true);
688 
689         _mint(msg.sender, totalSupply);
690     }
691 
692     receive() external payable {}
693 
694     function enableTrading() external onlyOwner {
695         tradingActive = true;
696         swapEnabled = true;
697         lastLpBurnTime = block.timestamp;
698     }
699 
700     function removeLimits() external onlyOwner returns (bool) {
701         limitsInEffect = false;
702         return true;
703     }
704 
705     function disableTransferDelay() external onlyOwner returns (bool) {
706         transferDelayEnabled = false;
707         return true;
708     }
709 
710     function updateSwapTokensAtAmount(uint256 newAmount)
711         external
712         onlyOwner
713         returns (bool)
714     {
715         require(
716             newAmount >= (totalSupply() * 1) / 100000,
717             "Swap amount cannot be lower than 0.001% total supply."
718         );
719         require(
720             newAmount <= (totalSupply() * 5) / 1000,
721             "Swap amount cannot be higher than 0.5% total supply."
722         );
723         swapTokensAtAmount = newAmount;
724         return true;
725     }
726 
727     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
730             "Cannot set maxTransactionAmount lower than 0.1%"
731         );
732         maxTransactionAmount = newNum * (10**18);
733     }
734 
735     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
736         require(
737             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
738             "Cannot set maxWallet lower than 0.5%"
739         );
740         maxWallet = newNum * (10**18);
741     }
742 
743     function excludeFromMaxTransaction(address updAds, bool isEx)
744         public
745         onlyOwner
746     {
747         _isExcludedMaxTransactionAmount[updAds] = isEx;
748     }
749 
750     function updateSwapEnabled(bool enabled) external onlyOwner {
751         swapEnabled = enabled;
752     }
753 
754     function updateBuyFees(
755         uint256 _marketingFee,
756         uint256 _liquidityFee,
757         uint256 _devFee
758     ) external onlyOwner {
759         buyMarketingFee = _marketingFee;
760         buyLiquidityFee = _liquidityFee;
761         buyDevFee = _devFee;
762         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
763         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
764     }
765 
766     function updateSellFees(
767         uint256 _marketingFee,
768         uint256 _liquidityFee,
769         uint256 _devFee
770     ) external onlyOwner {
771         sellMarketingFee = _marketingFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevFee = _devFee;
774         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
775         require(sellTotalFees <= 90, "Must keep fees at 90% or less");
776     }
777 
778     function excludeFromFees(address account, bool excluded) public onlyOwner {
779         _isExcludedFromFees[account] = excluded;
780         emit ExcludeFromFees(account, excluded);
781     }
782 
783     function setAutomatedMarketMakerPair(address pair, bool value)
784         public
785         onlyOwner
786     {
787         require(
788             pair != uniswapV2Pair,
789             "The pair cannot be removed from automatedMarketMakerPairs"
790         );
791 
792         _setAutomatedMarketMakerPair(pair, value);
793     }
794 
795     function _setAutomatedMarketMakerPair(address pair, bool value) private {
796         automatedMarketMakerPairs[pair] = value;
797 
798         emit SetAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function updateMarketingWallet(address newMarketingWallet)
802         external
803         onlyOwner
804     {
805         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
806         marketingWallet = newMarketingWallet;
807     }
808 
809     function updateDevWallet(address newWallet) external onlyOwner {
810         emit devWalletUpdated(newWallet, devWallet);
811         devWallet = newWallet;
812     }
813 
814     function isExcludedFromFees(address account) public view returns (bool) {
815         return _isExcludedFromFees[account];
816     }
817 
818     event BoughtEarly(address indexed sniper);
819 
820     function _transfer(
821         address from,
822         address to,
823         uint256 amount
824     ) internal override {
825         require(from != address(0), "ERC20: transfer from the zero address");
826         require(to != address(0), "ERC20: transfer to the zero address");
827 
828         if (amount == 0) {
829             super._transfer(from, to, 0);
830             return;
831         }
832 
833         if (limitsInEffect) {
834             if (
835                 from != owner() &&
836                 to != owner() &&
837                 to != address(0) &&
838                 to != address(0xdead) &&
839                 !swapping
840             ) {
841                 if (!tradingActive) {
842                     require(
843                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
844                         "Trading is not active."
845                     );
846                 }
847 
848                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
849                 if (transferDelayEnabled) {
850                     if (
851                         to != owner() &&
852                         to != address(uniswapV2Router) &&
853                         to != address(uniswapV2Pair)
854                     ) {
855                         require(
856                             _holderLastTransferTimestamp[tx.origin] <
857                                 block.number,
858                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
859                         );
860                         _holderLastTransferTimestamp[tx.origin] = block.number;
861                     }
862                 }
863 
864                 //when buy
865                 if (
866                     automatedMarketMakerPairs[from] &&
867                     !_isExcludedMaxTransactionAmount[to]
868                 ) {
869                     require(
870                         amount <= maxTransactionAmount,
871                         "Buy transfer amount exceeds the maxTransactionAmount."
872                     );
873                     require(
874                         amount + balanceOf(to) <= maxWallet,
875                         "Max wallet exceeded"
876                     );
877                 }
878                 //when sell
879                 else if (
880                     automatedMarketMakerPairs[to] &&
881                     !_isExcludedMaxTransactionAmount[from]
882                 ) {
883                     require(
884                         amount <= maxTransactionAmount,
885                         "Sell transfer amount exceeds the maxTransactionAmount."
886                     );
887                 } else if (!_isExcludedMaxTransactionAmount[to]) {
888                     require(
889                         amount + balanceOf(to) <= maxWallet,
890                         "Max wallet exceeded"
891                     );
892                 }
893             }
894         }
895 
896         uint256 contractTokenBalance = balanceOf(address(this));
897 
898         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
899 
900         if (
901             canSwap &&
902             swapEnabled &&
903             !swapping &&
904             !automatedMarketMakerPairs[from] &&
905             !_isExcludedFromFees[from] &&
906             !_isExcludedFromFees[to]
907         ) {
908             swapping = true;
909 
910             swapBack();
911 
912             swapping = false;
913         }
914 
915         if (
916             !swapping &&
917             automatedMarketMakerPairs[to] &&
918             lpBurnEnabled &&
919             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
920             !_isExcludedFromFees[from]
921         ) {
922             autoBurnLiquidityPairTokens();
923         }
924 
925         bool takeFee = !swapping;
926 
927         // if any account belongs to _isExcludedFromFee account then remove the fee
928         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
929             takeFee = false;
930         }
931 
932         uint256 fees = 0;
933         // only take fees on buys/sells, do not take on wallet transfers
934         if (takeFee) {
935             // on sell
936             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
937                 fees = amount.mul(sellTotalFees).div(100);
938                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
939                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
940                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
941             }
942             // on buy
943             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
944                 fees = amount.mul(buyTotalFees).div(100);
945                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
946                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
947                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
948             }
949 
950             if (fees > 0) {
951                 super._transfer(from, address(this), fees);
952             }
953 
954             amount -= fees;
955         }
956 
957         super._transfer(from, to, amount);
958     }
959 
960     function swapTokensForEth(uint256 tokenAmount) private {
961         // generate the uniswap pair path of token -> weth
962         address[] memory path = new address[](2);
963         path[0] = address(this);
964         path[1] = uniswapV2Router.WETH();
965 
966         _approve(address(this), address(uniswapV2Router), tokenAmount);
967 
968         // make the swap
969         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
970             tokenAmount,
971             0, // accept any amount of ETH
972             path,
973             address(this),
974             block.timestamp
975         );
976     }
977 
978     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
979         // approve token transfer to cover all possible scenarios
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         // add the liquidity
983         uniswapV2Router.addLiquidityETH{value: ethAmount}(
984             address(this),
985             tokenAmount,
986             0, // slippage is unavoidable
987             0, // slippage is unavoidable
988             deadAddress,
989             block.timestamp
990         );
991     }
992 
993     function swapBack() private {
994         uint256 contractBalance = balanceOf(address(this));
995         uint256 totalTokensToSwap = tokensForLiquidity +
996             tokensForMarketing +
997             tokensForDev;
998         bool success;
999 
1000         if (contractBalance == 0 || totalTokensToSwap == 0) {
1001             return;
1002         }
1003 
1004         if (contractBalance > swapTokensAtAmount * 20) {
1005             contractBalance = swapTokensAtAmount * 20;
1006         }
1007 
1008         // Halve the amount of liquidity tokens
1009         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1010             totalTokensToSwap /
1011             2;
1012         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1013 
1014         uint256 initialETHBalance = address(this).balance;
1015 
1016         swapTokensForEth(amountToSwapForETH);
1017 
1018         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1019 
1020         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1021             totalTokensToSwap
1022         );
1023         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1024 
1025         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1026 
1027         tokensForLiquidity = 0;
1028         tokensForMarketing = 0;
1029         tokensForDev = 0;
1030 
1031         (success, ) = address(devWallet).call{value: ethForDev}("");
1032 
1033         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1034             addLiquidity(liquidityTokens, ethForLiquidity);
1035             emit SwapAndLiquify(
1036                 amountToSwapForETH,
1037                 ethForLiquidity,
1038                 tokensForLiquidity
1039             );
1040         }
1041 
1042         (success, ) = address(marketingWallet).call{
1043             value: address(this).balance
1044         }("");
1045     }
1046 
1047     function setAutoLPBurnSettings(
1048         uint256 _frequencyInSeconds,
1049         uint256 _percent,
1050         bool _Enabled
1051     ) external onlyOwner {
1052         require(
1053             _frequencyInSeconds >= 600,
1054             "cannot set buyback more often than every 10 minutes"
1055         );
1056         require(
1057             _percent <= 1000 && _percent >= 0,
1058             "Must set auto LP burn percent between 0% and 10%"
1059         );
1060         lpBurnFrequency = _frequencyInSeconds;
1061         percentForLPBurn = _percent;
1062         lpBurnEnabled = _Enabled;
1063     }
1064 
1065     function autoBurnLiquidityPairTokens() internal returns (bool) {
1066         lastLpBurnTime = block.timestamp;
1067 
1068         // get balance of liquidity pair
1069         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1070 
1071         // calculate amount to burn
1072         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1073             10000
1074         );
1075 
1076         // pull tokens from pancakePair liquidity and move to dead address permanently
1077         if (amountToBurn > 0) {
1078             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1079         }
1080 
1081         //sync price since this is not in a swap transaction!
1082         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1083         pair.sync();
1084         emit AutoNukeLP();
1085         return true;
1086     }
1087 
1088     function manualBurnLiquidityPairTokens(uint256 percent)
1089         external
1090         onlyOwner
1091         returns (bool)
1092     {
1093         require(
1094             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1095             "Must wait for cooldown to finish"
1096         );
1097         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1098         lastManualLpBurnTime = block.timestamp;
1099 
1100         // get balance of liquidity pair
1101         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1102 
1103         // calculate amount to burn
1104         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1105 
1106         // pull tokens from pancakePair liquidity and move to dead address permanently
1107         if (amountToBurn > 0) {
1108             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1109         }
1110 
1111         //sync price since this is not in a swap transaction!
1112         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1113         pair.sync();
1114         emit ManualNukeLP();
1115         return true;
1116     }
1117 }