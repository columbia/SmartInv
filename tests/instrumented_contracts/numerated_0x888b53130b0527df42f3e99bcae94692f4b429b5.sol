1 /*
2 Decentra Tool
3 Tg: https://t.me/DecentraTools_Erc20
4 Website: decentratools.tech
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.16;
9 pragma experimental ABIEncoderV2;
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
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner { //Change
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
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
58     function balanceOf(address account) external view returns (uint256);
59     function transfer(address recipient, uint256 amount) external returns (bool);
60     function allowance(address owner, address spender) external view returns (uint256);
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 interface IERC20Metadata is IERC20 {
74 
75     function name() external view returns (string memory);
76     function symbol() external view returns (string memory);
77     function decimals() external view returns (uint8);
78 }
79 
80 
81 contract ERC20 is Context, IERC20, IERC20Metadata {
82     mapping(address => uint256) private _balances;
83     mapping(address => mapping(address => uint256)) private _allowances;
84 
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89 
90     constructor(string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102 
103     function decimals() public view virtual override returns (uint8) {
104         return 18;
105     }
106 
107     function totalSupply() public view virtual override returns (uint256) {
108         return _totalSupply;
109     }
110 
111     function balanceOf(address account) public view virtual override returns (uint256) {
112         return _balances[account];
113     }
114 
115     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender) public view virtual override returns (uint256) {
121         return _allowances[owner][spender];
122     }
123 
124     function approve(address spender, uint256 amount) public virtual override returns (bool) {
125         _approve(_msgSender(), spender, amount);
126         return true;
127     }
128 
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) public virtual override returns (bool) {
134         _transfer(sender, recipient, amount);
135 
136         uint256 currentAllowance = _allowances[sender][_msgSender()];
137         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
138         unchecked {
139             _approve(sender, _msgSender(), currentAllowance - amount);
140         }
141 
142         return true;
143     }
144 
145     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
146         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
147         return true;
148     }
149 
150     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
151         uint256 currentAllowance = _allowances[_msgSender()][spender];
152         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
153         unchecked {
154             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
155         }
156 
157         return true;
158     }
159 
160     function _transfer(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) internal virtual {
165         require(sender != address(0), "ERC20: transfer from the zero address");
166         require(recipient != address(0), "ERC20: transfer to the zero address");
167 
168         _beforeTokenTransfer(sender, recipient, amount);
169 
170         uint256 senderBalance = _balances[sender];
171         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
172         unchecked {
173             _balances[sender] = senderBalance - amount;
174         }
175         _balances[recipient] += amount;
176 
177         emit Transfer(sender, recipient, amount);
178 
179         _afterTokenTransfer(sender, recipient, amount);
180     }
181 
182     function _mint(address account, uint256 amount) internal virtual {
183         require(account != address(0), "ERC20: mint to the zero address");
184 
185         _beforeTokenTransfer(address(0), account, amount);
186 
187         _totalSupply += amount;
188         _balances[account] += amount;
189         emit Transfer(address(0), account, amount);
190 
191         _afterTokenTransfer(address(0), account, amount);
192     }
193 
194     function _approve(
195         address owner,
196         address spender,
197         uint256 amount
198     ) internal virtual {
199         require(owner != address(0), "ERC20: approve from the zero address");
200         require(spender != address(0), "ERC20: approve to the zero address");
201 
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _beforeTokenTransfer(
207         address from,
208         address to,
209         uint256 amount
210     ) internal virtual {}
211 
212     function _afterTokenTransfer(
213         address from,
214         address to,
215         uint256 amount
216     ) internal virtual {}
217 }
218 
219 library SafeMath {
220 
221     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             uint256 c = a + b;
224             if (c < a) return (false, 0);
225             return (true, c);
226         }
227     }
228 
229     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
230         unchecked {
231             if (b > a) return (false, 0);
232             return (true, a - b);
233         }
234     }
235 
236     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (a == 0) return (true, 0);
239             uint256 c = a * b;
240             if (c / a != b) return (false, 0);
241             return (true, c);
242         }
243     }
244 
245     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             if (b == 0) return (false, 0);
248             return (true, a / b);
249         }
250     }
251 
252     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b == 0) return (false, 0);
255             return (true, a % b);
256         }
257     }
258 
259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a + b;
261     }
262 
263     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a - b;
265     }
266 
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a * b;
269     }
270 
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a % b;
277     }
278 
279     function sub(
280         uint256 a,
281         uint256 b,
282         string memory errorMessage
283     ) internal pure returns (uint256) {
284         unchecked {
285             require(b <= a, errorMessage);
286             return a - b;
287         }
288     }
289 
290     function div(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         unchecked {
296             require(b > 0, errorMessage);
297             return a / b;
298         }
299     }
300 
301     function mod(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a % b;
309         }
310     }
311 }
312 
313 interface IUniswapV2Factory {
314     event PairCreated(
315         address indexed token0,
316         address indexed token1,
317         address pair,
318         uint256
319     );
320 
321     function feeTo() external view returns (address);
322 
323     function feeToSetter() external view returns (address);
324 
325     function getPair(address tokenA, address tokenB)
326         external
327         view
328         returns (address pair);
329 
330     function allPairs(uint256) external view returns (address pair);
331 
332     function allPairsLength() external view returns (uint256);
333 
334     function createPair(address tokenA, address tokenB)
335         external
336         returns (address pair);
337 
338     function setFeeTo(address) external;
339 
340     function setFeeToSetter(address) external;
341 }
342 
343 interface IUniswapV2Pair {
344     event Approval(
345         address indexed owner,
346         address indexed spender,
347         uint256 value
348     );
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     function name() external pure returns (string memory);
352 
353     function symbol() external pure returns (string memory);
354 
355     function decimals() external pure returns (uint8);
356 
357     function totalSupply() external view returns (uint256);
358 
359     function balanceOf(address owner) external view returns (uint256);
360 
361     function allowance(address owner, address spender)
362         external
363         view
364         returns (uint256);
365 
366     function approve(address spender, uint256 value) external returns (bool);
367 
368     function transfer(address to, uint256 value) external returns (bool);
369 
370     function transferFrom(
371         address from,
372         address to,
373         uint256 value
374     ) external returns (bool);
375 
376     function DOMAIN_SEPARATOR() external view returns (bytes32);
377 
378     function PERMIT_TYPEHASH() external pure returns (bytes32);
379 
380     function nonces(address owner) external view returns (uint256);
381 
382     function permit(
383         address owner,
384         address spender,
385         uint256 value,
386         uint256 deadline,
387         uint8 v,
388         bytes32 r,
389         bytes32 s
390     ) external;
391 
392     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
393 
394     event Swap(
395         address indexed sender,
396         uint256 amount0In,
397         uint256 amount1In,
398         uint256 amount0Out,
399         uint256 amount1Out,
400         address indexed to
401     );
402     event Sync(uint112 reserve0, uint112 reserve1);
403 
404     function MINIMUM_LIQUIDITY() external pure returns (uint256);
405 
406     function factory() external view returns (address);
407 
408     function token0() external view returns (address);
409 
410     function token1() external view returns (address);
411 
412     function getReserves()
413         external
414         view
415         returns (
416             uint112 reserve0,
417             uint112 reserve1,
418             uint32 blockTimestampLast
419         );
420 
421     function price0CumulativeLast() external view returns (uint256);
422 
423     function price1CumulativeLast() external view returns (uint256);
424 
425     function kLast() external view returns (uint256);
426 
427     function mint(address to) external returns (uint256 liquidity);
428 
429     function swap(
430         uint256 amount0Out,
431         uint256 amount1Out,
432         address to,
433         bytes calldata data
434     ) external;
435 
436     function skim(address to) external;
437 
438     function sync() external;
439 
440     function initialize(address, address) external;
441 }
442 
443 interface IUniswapV2Router02 {
444     function factory() external pure returns (address);
445 
446     function WETH() external pure returns (address);
447 
448     function addLiquidity(
449         address tokenA,
450         address tokenB,
451         uint256 amountADesired,
452         uint256 amountBDesired,
453         uint256 amountAMin,
454         uint256 amountBMin,
455         address to,
456         uint256 deadline
457     )
458         external
459         returns (
460             uint256 amountA,
461             uint256 amountB,
462             uint256 liquidity
463         );
464 
465     function addLiquidityETH(
466         address token,
467         uint256 amountTokenDesired,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline
472     )
473         external
474         payable
475         returns (
476             uint256 amountToken,
477             uint256 amountETH,
478             uint256 liquidity
479         );
480 
481     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
482         uint256 amountIn,
483         uint256 amountOutMin,
484         address[] calldata path,
485         address to,
486         uint256 deadline
487     ) external;
488 
489     function swapExactETHForTokensSupportingFeeOnTransferTokens(
490         uint256 amountOutMin,
491         address[] calldata path,
492         address to,
493         uint256 deadline
494     ) external payable;
495 
496     function swapExactTokensForETHSupportingFeeOnTransferTokens(
497         uint256 amountIn,
498         uint256 amountOutMin,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external;
503 }
504 
505 contract DecentraTool is ERC20, Ownable {
506     using SafeMath for uint256;
507 
508     IUniswapV2Router02 public immutable uniswapV2Router;
509     address public immutable uniswapV2Pair;
510     address public constant deadAddress = address(0xdead);
511 
512     bool private swapping;
513 
514     address public marketingWallet;
515 
516     uint256 public maxTransactionAmount;
517     uint256 public swapTokensAtAmount;
518     uint256 public maxWallet;
519 
520     bool public tradingActive = false;
521     bool public swapEnabled = false;
522 
523     uint256 public buyTotalFees;
524     uint256 private buyMarketingFee;
525     uint256 private buyLiquidityFee;
526 
527     uint256 public sellTotalFees;
528     uint256 private sellMarketingFee;
529     uint256 private sellLiquidityFee;
530 
531     uint256 private tokensForMarketing;
532     uint256 private tokensForLiquidity;
533     uint256 private previousFee;
534 
535     mapping(address => bool) private _isExcludedFromFees;
536     mapping(address => bool) private _isExcludedMaxTransactionAmount;
537     mapping(address => bool) private automatedMarketMakerPairs;
538     mapping(address => bool) public bots;
539     mapping (address => uint256) public _buyMap;
540     event UpdateUniswapV2Router(
541         address indexed newAddress,
542         address indexed oldAddress
543     );
544 
545     event ExcludeFromFees(address indexed account, bool isExcluded);
546 
547     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
548 
549     event marketingWalletUpdated(
550         address indexed newWallet,
551         address indexed oldWallet
552     );
553 
554     event SwapAndLiquify(
555         uint256 tokensSwapped,
556         uint256 ethReceived,
557         uint256 tokensIntoLiquidity
558     );
559 
560     constructor() ERC20(" Decentra Tool ", "DCT") {
561         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
562             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
563         );
564 
565         excludeFromMaxTransaction(address(_uniswapV2Router), true);
566         uniswapV2Router = _uniswapV2Router;
567 
568         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
569             .createPair(address(this), _uniswapV2Router.WETH());
570         excludeFromMaxTransaction(address(uniswapV2Pair), true);
571         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
572 
573         uint256 _buyMarketingFee = 5;
574         uint256 _buyLiquidityFee = 0;
575 
576         uint256 _sellMarketingFee = 95;
577         uint256 _sellLiquidityFee = 0;
578 
579         uint256 totalSupply = 1000000000 * 1e18;
580 
581         maxTransactionAmount = 10000000 * 1e18;
582         maxWallet = 20000000 * 1e18;
583         swapTokensAtAmount = (totalSupply * 5) / 10000;
584 
585         buyMarketingFee = _buyMarketingFee;
586         buyLiquidityFee = _buyLiquidityFee;
587         buyTotalFees = buyMarketingFee + buyLiquidityFee;
588 
589         sellMarketingFee = _sellMarketingFee;
590         sellLiquidityFee = _sellLiquidityFee;
591         sellTotalFees = sellMarketingFee + sellLiquidityFee;
592         previousFee = sellTotalFees;
593 
594         marketingWallet = address(0x05B1065A38eed8015b977F0528D057E560Aa4058);
595 
596         excludeFromFees(owner(), true);
597         excludeFromFees(address(this), true);
598         excludeFromFees(address(0xdead), true);
599 
600         excludeFromMaxTransaction(owner(), true);
601         excludeFromMaxTransaction(address(this), true);
602         excludeFromMaxTransaction(address(0xdead), true);
603 
604         _mint(msg.sender, totalSupply);
605     }
606 
607     receive() external payable {}
608 
609     function enableTrading() external onlyOwner {
610         tradingActive = true;
611         swapEnabled = true;
612     }
613 
614     function updateSwapTokensAtAmount(uint256 newAmount)
615         external
616         onlyOwner
617         returns (bool)
618     {
619         require(
620             newAmount >= (totalSupply() * 1) / 100000,
621             "Swap amount cannot be lower than 0.001% total supply."
622         );
623         require(
624             newAmount <= (totalSupply() * 5) / 1000,
625             "Swap amount cannot be higher than 0.5% total supply."
626         );
627         swapTokensAtAmount = newAmount;
628         return true;
629     }
630 
631     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
632         require(
633             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
634             "Cannot set maxTxn lower than 0.5%"
635         );
636         require(
637             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
638             "Cannot set maxWallet lower than 0.5%"
639         );
640         maxWallet = newMaxWalletNum * (10**18);
641         maxTransactionAmount = newTxnNum * (10**18);
642     }
643 
644     function blockBots(address[] memory bots_) public onlyOwner {
645         for (uint256 i = 0; i < bots_.length; i++) {
646             bots[bots_[i]] = true;
647         }
648     }
649 
650     function unblockBot(address notbot) public onlyOwner {
651         bots[notbot] = false;
652     }
653 
654     function excludeFromMaxTransaction(address updAds, bool isEx)
655         public
656         onlyOwner
657     {
658         _isExcludedMaxTransactionAmount[updAds] = isEx;
659     }
660 
661     function updateBuyFees(
662         uint256 _marketingFee,
663         uint256 _liquidityFee
664     ) external onlyOwner {
665         buyMarketingFee = _marketingFee;
666         buyLiquidityFee = _liquidityFee;
667         buyTotalFees = buyMarketingFee + buyLiquidityFee;
668         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
669     }
670 
671     function updateSellFees(
672         uint256 _marketingFee,
673         uint256 _liquidityFee
674     ) external onlyOwner {
675         sellMarketingFee = _marketingFee;
676         sellLiquidityFee = _liquidityFee;
677         sellTotalFees = sellMarketingFee + sellLiquidityFee;
678         previousFee = sellTotalFees;
679         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
680     }
681 
682     function excludeFromFees(address account, bool excluded) public onlyOwner {
683         _isExcludedFromFees[account] = excluded;
684         emit ExcludeFromFees(account, excluded);
685     }
686 
687     function setAutomatedMarketMakerPair(address pair, bool value)
688         public
689         onlyOwner
690     {
691         require(
692             pair != uniswapV2Pair,
693             "The pair cannot be removed from automatedMarketMakerPairs"
694         );
695 
696         _setAutomatedMarketMakerPair(pair, value);
697     }
698 
699     function _setAutomatedMarketMakerPair(address pair, bool value) private {
700         automatedMarketMakerPairs[pair] = value;
701 
702         emit SetAutomatedMarketMakerPair(pair, value);
703     }
704 
705     function isExcludedFromFees(address account) public view returns (bool) {
706         return _isExcludedFromFees[account];
707     }
708 
709     function _transfer(
710         address from,
711         address to,
712         uint256 amount
713     ) internal override {
714         require(from != address(0), "ERC20: transfer from the zero address");
715         require(to != address(0), "ERC20: transfer to the zero address");
716 
717         if (amount == 0) {
718             super._transfer(from, to, 0);
719             return;
720         }
721 
722                 if (
723                 from != owner() &&
724                 to != owner() &&
725                 to != address(0) &&
726                 to != address(0xdead) &&
727                 !swapping
728             ) {
729                 if (!tradingActive) {
730                     require(
731                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
732                         "Trading is not active."
733                     );
734                 }
735                 
736                 require(!bots[from] && !bots[to], "Your account is blacklisted!");
737 
738                 //when buy
739                 if (
740                     automatedMarketMakerPairs[from] &&
741                     !_isExcludedMaxTransactionAmount[to]
742                 ) {
743                     require(
744                         amount <= maxTransactionAmount,
745                         "Buy transfer amount exceeds the maxTransactionAmount."
746                     );
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max wallet exceeded"
750                     );
751                 }
752                 //when sell
753                 else if (
754                     automatedMarketMakerPairs[to] &&
755                     !_isExcludedMaxTransactionAmount[from]
756                 ) {
757                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
758                 } 
759                 
760                 else if (!_isExcludedMaxTransactionAmount[to]) {
761                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
762                 }
763             }
764 
765         uint256 contractTokenBalance = balanceOf(address(this));
766 
767         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
768 
769         if (
770             canSwap &&
771             swapEnabled &&
772             !swapping &&
773             !automatedMarketMakerPairs[from] &&
774             !_isExcludedFromFees[from] &&
775             !_isExcludedFromFees[to]
776         ) {
777             swapping = true;
778 
779             swapBack();
780 
781             swapping = false;
782         }
783 
784         bool takeFee = !swapping;
785 
786         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
787             takeFee = false;
788         }
789 
790         uint256 fees = 0;
791 
792         if (takeFee) {
793             // on sell
794             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
795                 fees = amount.mul(sellTotalFees).div(100);
796                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
797                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
798             }
799             // on buy
800             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
801                 fees = amount.mul(buyTotalFees).div(100);
802                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
803                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
804             }
805 
806             if (fees > 0) {
807                 super._transfer(from, address(this), fees);
808             }
809 
810             amount -= fees;
811         }
812 
813         super._transfer(from, to, amount);
814         sellTotalFees = previousFee;
815 
816     }
817 
818     function swapTokensForEth(uint256 tokenAmount) private {
819 
820         address[] memory path = new address[](2);
821         path[0] = address(this);
822         path[1] = uniswapV2Router.WETH();
823 
824         _approve(address(this), address(uniswapV2Router), tokenAmount);
825 
826         // make the swap
827         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
828             tokenAmount,
829             0,
830             path,
831             address(this),
832             block.timestamp
833         );
834     }
835 
836     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
837 
838         _approve(address(this), address(uniswapV2Router), tokenAmount);
839 
840         uniswapV2Router.addLiquidityETH{value: ethAmount}(
841             address(this),
842             tokenAmount,
843             0,
844             0,
845             deadAddress,
846             block.timestamp
847         );
848     }
849 
850     function swapBack() private {
851         uint256 contractBalance = balanceOf(address(this));
852         uint256 totalTokensToSwap = tokensForLiquidity +
853             tokensForMarketing;
854         bool success;
855 
856         if (contractBalance == 0 || totalTokensToSwap == 0) {
857             return;
858         }
859 
860         if (contractBalance > swapTokensAtAmount * 20) {
861             contractBalance = swapTokensAtAmount * 20;
862         }
863 
864         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
865             totalTokensToSwap /
866             2;
867         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
868 
869         uint256 initialETHBalance = address(this).balance;
870 
871         swapTokensForEth(amountToSwapForETH);
872 
873         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
874 
875         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
876             totalTokensToSwap
877         );
878 
879         uint256 ethForLiquidity = ethBalance - ethForMarketing;
880 
881         tokensForLiquidity = 0;
882         tokensForMarketing = 0;
883 
884         if (liquidityTokens > 0 && ethForLiquidity > 0) {
885             addLiquidity(liquidityTokens, ethForLiquidity);
886             emit SwapAndLiquify(
887                 amountToSwapForETH,
888                 ethForLiquidity,
889                 tokensForLiquidity
890             );
891         }
892 
893         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
894     }
895 }