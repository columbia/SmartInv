1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15  
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29     modifier onlyOwner() {
30         require(owner() == _msgSender(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     function renounceOwnership() public virtual onlyOwner {
35         _transferOwnership(address(0));
36     }
37 
38     function transferOwnership(address newOwner) public virtual onlyOwner {
39         require(newOwner != address(0), "Ownable: new owner is the zero address");
40         _transferOwnership(newOwner);
41     }
42 
43     function _transferOwnership(address newOwner) internal virtual {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48 }
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     function transferFrom(
57         address sender,
58         address recipient,
59         uint256 amount
60     ) external returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 interface IERC20Metadata is IERC20 {
67     function name() external view returns (string memory);
68     function symbol() external view returns (string memory);
69     function decimals() external view returns (uint8);
70 }
71 
72 contract ERC20 is Context, IERC20, IERC20Metadata {
73     mapping(address => uint256) private _balances;
74 
75     mapping(address => mapping(address => uint256)) private _allowances;
76 
77     uint256 private _totalSupply;
78 
79     string private _name;
80     string private _symbol;
81 
82     constructor(string memory name_, string memory symbol_) {
83         _name = name_;
84         _symbol = symbol_;
85     }
86 
87     function name() public view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() public view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     function decimals() public view virtual override returns (uint8) {
96         return 18;
97     }
98     function totalSupply() public view virtual override returns (uint256) {
99         return _totalSupply;
100     }
101     function balanceOf(address account) public view virtual override returns (uint256) {
102         return _balances[account];
103     }
104 
105     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(_msgSender(), recipient, amount);
107         return true;
108     }
109 
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114     function approve(address spender, uint256 amount) public virtual override returns (bool) {
115         _approve(_msgSender(), spender, amount);
116         return true;
117     }
118 
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) public virtual override returns (bool) {
124         _transfer(sender, recipient, amount);
125 
126         uint256 currentAllowance = _allowances[sender][_msgSender()];
127         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
128         unchecked {
129             _approve(sender, _msgSender(), currentAllowance - amount);
130         }
131 
132         return true;
133     }
134 
135     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
137         return true;
138     }
139 
140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
141         uint256 currentAllowance = _allowances[_msgSender()][spender];
142         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
143         unchecked {
144             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
145         }
146 
147         return true;
148     }
149 
150    
151     function _transfer(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) internal virtual {
156         require(sender != address(0), "ERC20: transfer from the zero address");
157         require(recipient != address(0), "ERC20: transfer to the zero address");
158 
159         _beforeTokenTransfer(sender, recipient, amount);
160 
161         uint256 senderBalance = _balances[sender];
162         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
163         unchecked {
164             _balances[sender] = senderBalance - amount;
165         }
166         _balances[recipient] += amount;
167 
168         emit Transfer(sender, recipient, amount);
169 
170         _afterTokenTransfer(sender, recipient, amount);
171     }
172 
173     function _mint(address account, uint256 amount) internal virtual {
174         require(account != address(0), "ERC20: mint to the zero address");
175 
176         _beforeTokenTransfer(address(0), account, amount);
177 
178         _totalSupply += amount;
179         _balances[account] += amount;
180         emit Transfer(address(0), account, amount);
181 
182         _afterTokenTransfer(address(0), account, amount);
183     }
184 
185     function _burn(address account, uint256 amount) internal virtual {
186         require(account != address(0), "ERC20: burn from the zero address");
187 
188         _beforeTokenTransfer(account, address(0), amount);
189 
190         uint256 accountBalance = _balances[account];
191         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
192         unchecked {
193             _balances[account] = accountBalance - amount;
194         }
195         _totalSupply -= amount;
196 
197         emit Transfer(account, address(0), amount);
198 
199         _afterTokenTransfer(account, address(0), amount);
200     }
201 
202     function _approve(
203         address owner,
204         address spender,
205         uint256 amount
206     ) internal virtual {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209 
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _beforeTokenTransfer(
215         address from,
216         address to,
217         uint256 amount
218     ) internal virtual {}
219 
220     function _afterTokenTransfer(
221         address from,
222         address to,
223         uint256 amount
224     ) internal virtual {}
225 }
226 
227 library SafeMath {
228     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         unchecked {
230             uint256 c = a + b;
231             if (c < a) return (false, 0);
232             return (true, c);
233         }
234     }
235 
236     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (b > a) return (false, 0);
239             return (true, a - b);
240         }
241     }
242 
243     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             if (a == 0) return (true, 0);
246             uint256 c = a * b;
247             if (c / a != b) return (false, 0);
248             return (true, c);
249         }
250     }
251 
252     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b == 0) return (false, 0);
255             return (true, a / b);
256         }
257     }
258 
259     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b == 0) return (false, 0);
262             return (true, a % b);
263         }
264     }
265 
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a + b;
268     }
269 
270     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a - b;
272     }
273 
274     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a * b;
276     }
277 
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a / b;
280     }
281 
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a % b;
284     }
285 
286     function sub(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b <= a, errorMessage);
293             return a - b;
294         }
295     }
296 
297     function div(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     function mod(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b > 0, errorMessage);
315             return a % b;
316         }
317     }
318 }
319 
320 interface IUniswapV2Factory {
321     event PairCreated(
322         address indexed token0,
323         address indexed token1,
324         address pair,
325         uint256
326     );
327 
328     function feeTo() external view returns (address);
329 
330     function feeToSetter() external view returns (address);
331 
332     function getPair(address tokenA, address tokenB)
333         external
334         view
335         returns (address pair);
336 
337     function allPairs(uint256) external view returns (address pair);
338 
339     function allPairsLength() external view returns (uint256);
340 
341     function createPair(address tokenA, address tokenB)
342         external
343         returns (address pair);
344 
345     function setFeeTo(address) external;
346 
347     function setFeeToSetter(address) external;
348 }
349 
350 interface IUniswapV2Pair {
351     event Approval(
352         address indexed owner,
353         address indexed spender,
354         uint256 value
355     );
356     event Transfer(address indexed from, address indexed to, uint256 value);
357 
358     function name() external pure returns (string memory);
359 
360     function symbol() external pure returns (string memory);
361 
362     function decimals() external pure returns (uint8);
363 
364     function totalSupply() external view returns (uint256);
365 
366     function balanceOf(address owner) external view returns (uint256);
367 
368     function allowance(address owner, address spender)
369         external
370         view
371         returns (uint256);
372 
373     function approve(address spender, uint256 value) external returns (bool);
374 
375     function transfer(address to, uint256 value) external returns (bool);
376 
377     function transferFrom(
378         address from,
379         address to,
380         uint256 value
381     ) external returns (bool);
382 
383     function DOMAIN_SEPARATOR() external view returns (bytes32);
384 
385     function PERMIT_TYPEHASH() external pure returns (bytes32);
386 
387     function nonces(address owner) external view returns (uint256);
388 
389     function permit(
390         address owner,
391         address spender,
392         uint256 value,
393         uint256 deadline,
394         uint8 v,
395         bytes32 r,
396         bytes32 s
397     ) external;
398 
399     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
400     event Burn(
401         address indexed sender,
402         uint256 amount0,
403         uint256 amount1,
404         address indexed to
405     );
406     event Swap(
407         address indexed sender,
408         uint256 amount0In,
409         uint256 amount1In,
410         uint256 amount0Out,
411         uint256 amount1Out,
412         address indexed to
413     );
414     event Sync(uint112 reserve0, uint112 reserve1);
415 
416     function MINIMUM_LIQUIDITY() external pure returns (uint256);
417 
418     function factory() external view returns (address);
419 
420     function token0() external view returns (address);
421 
422     function token1() external view returns (address);
423 
424     function getReserves()
425         external
426         view
427         returns (
428             uint112 reserve0,
429             uint112 reserve1,
430             uint32 blockTimestampLast
431         );
432 
433     function price0CumulativeLast() external view returns (uint256);
434 
435     function price1CumulativeLast() external view returns (uint256);
436 
437     function kLast() external view returns (uint256);
438 
439     function mint(address to) external returns (uint256 liquidity);
440 
441     function burn(address to)
442         external
443         returns (uint256 amount0, uint256 amount1);
444 
445     function swap(
446         uint256 amount0Out,
447         uint256 amount1Out,
448         address to,
449         bytes calldata data
450     ) external;
451 
452     function skim(address to) external;
453 
454     function sync() external;
455 
456     function initialize(address, address) external;
457 }
458 
459 
460 interface IUniswapV2Router02 {
461     function factory() external pure returns (address);
462 
463     function WETH() external pure returns (address);
464 
465     function addLiquidity(
466         address tokenA,
467         address tokenB,
468         uint256 amountADesired,
469         uint256 amountBDesired,
470         uint256 amountAMin,
471         uint256 amountBMin,
472         address to,
473         uint256 deadline
474     )
475         external
476         returns (
477             uint256 amountA,
478             uint256 amountB,
479             uint256 liquidity
480         );
481 
482     function addLiquidityETH(
483         address token,
484         uint256 amountTokenDesired,
485         uint256 amountTokenMin,
486         uint256 amountETHMin,
487         address to,
488         uint256 deadline
489     )
490         external
491         payable
492         returns (
493             uint256 amountToken,
494             uint256 amountETH,
495             uint256 liquidity
496         );
497 
498     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
499         uint256 amountIn,
500         uint256 amountOutMin,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external;
505 
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external payable;
512 
513     function swapExactTokensForETHSupportingFeeOnTransferTokens(
514         uint256 amountIn,
515         uint256 amountOutMin,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external;
520 }
521 
522 contract WenMoon is ERC20, Ownable {
523     using SafeMath for uint256;
524 
525     IUniswapV2Router02 public immutable uniswapV2Router;
526     address public immutable uniswapV2Pair;
527     address public constant deadAddress = address(0xdead);
528 
529     bool private swapping;
530 
531     address public marketingWallet;
532     address public devWallet;
533 
534     uint256 public maxTransactionAmount;
535     uint256 public swapTokensAtAmount;
536     uint256 public maxWallet;
537 
538     uint256 public percentForLPBurn = 25; // 25 = .25%
539     bool public lpBurnEnabled = true;
540     uint256 public lpBurnFrequency = 3600 seconds;
541     uint256 public lastLpBurnTime;
542 
543     uint256 public manualBurnFrequency = 30 minutes;
544     uint256 public lastManualLpBurnTime;
545 
546     bool public limitsInEffect = true;
547     bool public tradingActive = false;
548     bool public swapEnabled = false;
549 
550     mapping(address => uint256) private _holderLastTransferTimestamp; 
551     bool public transferDelayEnabled = true;
552 
553     uint256 public buyTotalFees;
554     uint256 public buyMarketingFee;
555     uint256 public buyLiquidityFee;
556     uint256 public buyDevFee;
557 
558     uint256 public sellTotalFees;
559     uint256 public sellMarketingFee;
560     uint256 public sellLiquidityFee;
561     uint256 public sellDevFee;
562 
563     uint256 public tokensForMarketing;
564     uint256 public tokensForLiquidity;
565     uint256 public tokensForDev;
566     mapping(address => bool) private _isExcludedFromFees;
567     mapping(address => bool) public _isExcludedMaxTransactionAmount;
568     mapping(address => bool) public automatedMarketMakerPairs;
569 
570     event UpdateUniswapV2Router(
571         address indexed newAddress,
572         address indexed oldAddress
573     );
574 
575     event ExcludeFromFees(address indexed account, bool isExcluded);
576 
577     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
578 
579     event marketingWalletUpdated(
580         address indexed newWallet,
581         address indexed oldWallet
582     );
583 
584     event devWalletUpdated(
585         address indexed newWallet,
586         address indexed oldWallet
587     );
588 
589     event SwapAndLiquify(
590         uint256 tokensSwapped,
591         uint256 ethReceived,
592         uint256 tokensIntoLiquidity
593     );
594 
595     event AutoNukeLP();
596 
597     event ManualNukeLP();
598 
599     constructor() ERC20("WenMoon", "NGMI") {
600         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
601             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
602         );
603 
604         excludeFromMaxTransaction(address(_uniswapV2Router), true);
605         uniswapV2Router = _uniswapV2Router;
606 
607         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
608             .createPair(address(this), _uniswapV2Router.WETH());
609         excludeFromMaxTransaction(address(uniswapV2Pair), true);
610         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
611 
612         uint256 _buyMarketingFee = 0;
613         uint256 _buyLiquidityFee = 0;
614         uint256 _buyDevFee = 0;
615 
616         uint256 _sellMarketingFee = 0;
617         uint256 _sellLiquidityFee = 0;
618         uint256 _sellDevFee = 6;
619 
620         uint256 totalSupply = 1_000_000_000 * 1e18;
621 
622         maxTransactionAmount = 30_000_000 * 1e18;
623         maxWallet = 30_000_000 * 1e18;
624         swapTokensAtAmount = (totalSupply * 5) / 10000;
625 
626         buyMarketingFee = _buyMarketingFee;
627         buyLiquidityFee = _buyLiquidityFee;
628         buyDevFee = _buyDevFee;
629         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
630 
631         sellMarketingFee = _sellMarketingFee;
632         sellLiquidityFee = _sellLiquidityFee;
633         sellDevFee = _sellDevFee;
634         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
635 
636         marketingWallet = address(0x2Ffb4CEa973C2bfc7b4433753D116e1484D1309E);
637         devWallet = address(0x2Ffb4CEa973C2bfc7b4433753D116e1484D1309E);
638 
639         excludeFromFees(owner(), true);
640         excludeFromFees(address(this), true);
641         excludeFromFees(address(0xdead), true);
642 
643         excludeFromMaxTransaction(owner(), true);
644         excludeFromMaxTransaction(address(this), true);
645         excludeFromMaxTransaction(address(0xdead), true);
646         _mint(msg.sender, totalSupply);
647     }
648 
649     receive() external payable {}
650 
651     function enableTrading() external onlyOwner {
652         tradingActive = true;
653         swapEnabled = true;
654         lastLpBurnTime = block.timestamp;
655     }
656 
657     function removeLimits() external onlyOwner returns (bool) {
658         limitsInEffect = false;
659         return true;
660     }
661 
662     function disableTransferDelay() external onlyOwner returns (bool) {
663         transferDelayEnabled = false;
664         return true;
665     }
666 
667     function updateSwapTokensAtAmount(uint256 newAmount)
668         external
669         onlyOwner
670         returns (bool)
671     {
672         require(
673             newAmount >= (totalSupply() * 1) / 100000,
674             "Swap amount cannot be lower than 0.001% total supply."
675         );
676         require(
677             newAmount <= (totalSupply() * 5) / 1000,
678             "Swap amount cannot be higher than 0.5% total supply."
679         );
680         swapTokensAtAmount = newAmount;
681         return true;
682     }
683 
684     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
685         require(
686             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
687             "Cannot set maxTransactionAmount lower than 0.1%"
688         );
689         maxTransactionAmount = newNum * (10**18);
690     }
691 
692     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
693         require(
694             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
695             "Cannot set maxWallet lower than 0.5%"
696         );
697         maxWallet = newNum * (10**18);
698     }
699 
700     function excludeFromMaxTransaction(address updAds, bool isEx)
701         public
702         onlyOwner
703     {
704         _isExcludedMaxTransactionAmount[updAds] = isEx;
705     }
706 
707     function updateSwapEnabled(bool enabled) external onlyOwner {
708         swapEnabled = enabled;
709     }
710 
711     function updateBuyFees(
712         uint256 _marketingFee,
713         uint256 _liquidityFee,
714         uint256 _devFee
715     ) external onlyOwner {
716         buyMarketingFee = _marketingFee;
717         buyLiquidityFee = _liquidityFee;
718         buyDevFee = _devFee;
719         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
720         require(buyTotalFees <= 9, "Must keep fees at 11% or less");
721     }
722 
723     function updateSellFees(
724         uint256 _marketingFee,
725         uint256 _liquidityFee,
726         uint256 _devFee
727     ) external onlyOwner {
728         sellMarketingFee = _marketingFee;
729         sellLiquidityFee = _liquidityFee;
730         sellDevFee = _devFee;
731         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
732         require(sellTotalFees <= 13, "Must keep fees at 11% or less");
733     }
734 
735     function excludeFromFees(address account, bool excluded) public onlyOwner {
736         _isExcludedFromFees[account] = excluded;
737         emit ExcludeFromFees(account, excluded);
738     }
739 
740     function setAutomatedMarketMakerPair(address pair, bool value)
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
758     function updateMarketingWallet(address newMarketingWallet)
759         external
760         onlyOwner
761     {
762         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
763         marketingWallet = newMarketingWallet;
764     }
765 
766     function updateDevWallet(address newWallet) external onlyOwner {
767         emit devWalletUpdated(newWallet, devWallet);
768         devWallet = newWallet;
769     }
770 
771     function isExcludedFromFees(address account) public view returns (bool) {
772         return _isExcludedFromFees[account];
773     }
774 
775     event BoughtEarly(address indexed sniper);
776 
777     function _transfer(
778         address from,
779         address to,
780         uint256 amount
781     ) internal override {
782         require(from != address(0), "ERC20: transfer from the zero address");
783         require(to != address(0), "ERC20: transfer to the zero address");
784 
785         if (amount == 0) {
786             super._transfer(from, to, 0);
787             return;
788         }
789 
790         if (limitsInEffect) {
791             if (
792                 from != owner() &&
793                 to != owner() &&
794                 to != address(0) &&
795                 to != address(0xdead) &&
796                 !swapping
797             ) {
798                 if (!tradingActive) {
799                     require(
800                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
801                         "Trading is not active."
802                     );
803                 }
804 
805                 if (transferDelayEnabled) {
806                     if (
807                         to != owner() &&
808                         to != address(uniswapV2Router) &&
809                         to != address(uniswapV2Pair)
810                     ) {
811                         require(
812                             _holderLastTransferTimestamp[tx.origin] <
813                                 block.number,
814                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
815                         );
816                         _holderLastTransferTimestamp[tx.origin] = block.number;
817                     }
818                 }
819 
820                 if (
821                     automatedMarketMakerPairs[from] &&
822                     !_isExcludedMaxTransactionAmount[to]
823                 ) {
824                     require(
825                         amount <= maxTransactionAmount,
826                         "Buy transfer amount exceeds the maxTransactionAmount."
827                     );
828                     require(
829                         amount + balanceOf(to) <= maxWallet,
830                         "Max wallet exceeded"
831                     );
832                 }
833                 else if (
834                     automatedMarketMakerPairs[to] &&
835                     !_isExcludedMaxTransactionAmount[from]
836                 ) {
837                     require(
838                         amount <= maxTransactionAmount,
839                         "Sell transfer amount exceeds the maxTransactionAmount."
840                     );
841                 } else if (!_isExcludedMaxTransactionAmount[to]) {
842                     require(
843                         amount + balanceOf(to) <= maxWallet,
844                         "Max wallet exceeded"
845                     );
846                 }
847             }
848         }
849 
850         uint256 contractTokenBalance = balanceOf(address(this));
851 
852         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
853 
854         if (
855             canSwap &&
856             swapEnabled &&
857             !swapping &&
858             !automatedMarketMakerPairs[from] &&
859             !_isExcludedFromFees[from] &&
860             !_isExcludedFromFees[to]
861         ) {
862             swapping = true;
863 
864             swapBack();
865 
866             swapping = false;
867         }
868 
869         if (
870             !swapping &&
871             automatedMarketMakerPairs[to] &&
872             lpBurnEnabled &&
873             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
874             !_isExcludedFromFees[from]
875         ) {
876             autoBurnLiquidityPairTokens();
877         }
878 
879         bool takeFee = !swapping;
880 
881         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
882             takeFee = false;
883         }
884 
885         uint256 fees = 0;
886         if (takeFee) {
887             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
888                 fees = amount.mul(sellTotalFees).div(100);
889                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
890                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
891                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
892             }
893             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
894                 fees = amount.mul(buyTotalFees).div(100);
895                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
896                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
897                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
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
910     function swapTokensForEth(uint256 tokenAmount) private {
911         address[] memory path = new address[](2);
912         path[0] = address(this);
913         path[1] = uniswapV2Router.WETH();
914 
915         _approve(address(this), address(uniswapV2Router), tokenAmount);
916 
917         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
918             tokenAmount,
919             0,
920             path,
921             address(this),
922             block.timestamp
923         );
924     }
925 
926     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
927         _approve(address(this), address(uniswapV2Router), tokenAmount);
928 
929         uniswapV2Router.addLiquidityETH{value: ethAmount}(
930             address(this),
931             tokenAmount,
932             0,
933             0,
934             deadAddress,
935             block.timestamp
936         );
937     }
938 
939     function swapBack() private {
940         uint256 contractBalance = balanceOf(address(this));
941         uint256 totalTokensToSwap = tokensForLiquidity +
942             tokensForMarketing +
943             tokensForDev;
944         bool success;
945 
946         if (contractBalance == 0 || totalTokensToSwap == 0) {
947             return;
948         }
949 
950         if (contractBalance > swapTokensAtAmount * 20) {
951             contractBalance = swapTokensAtAmount * 20;
952         }
953 
954         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
955             totalTokensToSwap /
956             2;
957         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
958 
959         uint256 initialETHBalance = address(this).balance;
960 
961         swapTokensForEth(amountToSwapForETH);
962 
963         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
964 
965         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
966             totalTokensToSwap
967         );
968         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
969 
970         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
971 
972         tokensForLiquidity = 0;
973         tokensForMarketing = 0;
974         tokensForDev = 0;
975 
976         (success, ) = address(devWallet).call{value: ethForDev}("");
977 
978         if (liquidityTokens > 0 && ethForLiquidity > 0) {
979             addLiquidity(liquidityTokens, ethForLiquidity);
980             emit SwapAndLiquify(
981                 amountToSwapForETH,
982                 ethForLiquidity,
983                 tokensForLiquidity
984             );
985         }
986 
987         (success, ) = address(marketingWallet).call{
988             value: address(this).balance
989         }("");
990     }
991 
992     function setAutoLPBurnSettings(
993         uint256 _frequencyInSeconds,
994         uint256 _percent,
995         bool _Enabled
996     ) external onlyOwner {
997         require(
998             _frequencyInSeconds >= 600,
999             "cannot set buyback more often than every 10 minutes"
1000         );
1001         require(
1002             _percent <= 1000 && _percent >= 0,
1003             "Must set auto LP burn percent between 0% and 10%"
1004         );
1005         lpBurnFrequency = _frequencyInSeconds;
1006         percentForLPBurn = _percent;
1007         lpBurnEnabled = _Enabled;
1008     }
1009 
1010     function autoBurnLiquidityPairTokens() internal returns (bool) {
1011         lastLpBurnTime = block.timestamp;
1012 
1013         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1014         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1015             10000
1016         );
1017 
1018         if (amountToBurn > 0) {
1019             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1020         }
1021 
1022         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1023         pair.sync();
1024         emit AutoNukeLP();
1025         return true;
1026     }
1027 
1028     function manualBurnLiquidityPairTokens(uint256 percent)
1029         external
1030         onlyOwner
1031         returns (bool)
1032     {
1033         require(
1034             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1035             "Must wait for cooldown to finish"
1036         );
1037         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1038         lastManualLpBurnTime = block.timestamp;
1039 
1040         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1041 
1042         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1043 
1044         if (amountToBurn > 0) {
1045             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1046         }
1047 
1048         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1049         pair.sync();
1050         emit ManualNukeLP();
1051         return true;
1052     }
1053 }