1 //https://twitter.com/BoysClubERC
2 //http://boysclub.fun/
3 //https://t.me/BoysClubETH
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.16;
6 pragma experimental ABIEncoderV2;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner { //Change
37         _transferOwnership(address(0));
38     }
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
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 interface IERC20Metadata is IERC20 {
71 
72     function name() external view returns (string memory);
73     function symbol() external view returns (string memory);
74     function decimals() external view returns (uint8);
75 }
76 
77 
78 contract ERC20 is Context, IERC20, IERC20Metadata {
79     mapping(address => uint256) private _balances;
80     mapping(address => mapping(address => uint256)) private _allowances;
81 
82     uint256 private _totalSupply;
83 
84     string private _name;
85     string private _symbol;
86 
87     constructor(string memory name_, string memory symbol_) {
88         _name = name_;
89         _symbol = symbol_;
90     }
91 
92     function name() public view virtual override returns (string memory) {
93         return _name;
94     }
95 
96     function symbol() public view virtual override returns (string memory) {
97         return _symbol;
98     }
99 
100     function decimals() public view virtual override returns (uint8) {
101         return 18;
102     }
103 
104     function totalSupply() public view virtual override returns (uint256) {
105         return _totalSupply;
106     }
107 
108     function balanceOf(address account) public view virtual override returns (uint256) {
109         return _balances[account];
110     }
111 
112     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
113         _transfer(_msgSender(), recipient, amount);
114         return true;
115     }
116 
117     function allowance(address owner, address spender) public view virtual override returns (uint256) {
118         return _allowances[owner][spender];
119     }
120 
121     function approve(address spender, uint256 amount) public virtual override returns (bool) {
122         _approve(_msgSender(), spender, amount);
123         return true;
124     }
125 
126     function transferFrom(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) public virtual override returns (bool) {
131         _transfer(sender, recipient, amount);
132 
133         uint256 currentAllowance = _allowances[sender][_msgSender()];
134         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
135         unchecked {
136             _approve(sender, _msgSender(), currentAllowance - amount);
137         }
138 
139         return true;
140     }
141 
142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
144         return true;
145     }
146 
147     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
148         uint256 currentAllowance = _allowances[_msgSender()][spender];
149         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
150         unchecked {
151             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
152         }
153 
154         return true;
155     }
156 
157     function _transfer(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) internal virtual {
162         require(sender != address(0), "ERC20: transfer from the zero address");
163         require(recipient != address(0), "ERC20: transfer to the zero address");
164 
165         _beforeTokenTransfer(sender, recipient, amount);
166 
167         uint256 senderBalance = _balances[sender];
168         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
169         unchecked {
170             _balances[sender] = senderBalance - amount;
171         }
172         _balances[recipient] += amount;
173 
174         emit Transfer(sender, recipient, amount);
175 
176         _afterTokenTransfer(sender, recipient, amount);
177     }
178 
179     function _mint(address account, uint256 amount) internal virtual {
180         require(account != address(0), "ERC20: mint to the zero address");
181 
182         _beforeTokenTransfer(address(0), account, amount);
183 
184         _totalSupply += amount;
185         _balances[account] += amount;
186         emit Transfer(address(0), account, amount);
187 
188         _afterTokenTransfer(address(0), account, amount);
189     }
190 
191     function _approve(
192         address owner,
193         address spender,
194         uint256 amount
195     ) internal virtual {
196         require(owner != address(0), "ERC20: approve from the zero address");
197         require(spender != address(0), "ERC20: approve to the zero address");
198 
199         _allowances[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202 
203     function _beforeTokenTransfer(
204         address from,
205         address to,
206         uint256 amount
207     ) internal virtual {}
208 
209     function _afterTokenTransfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {}
214 }
215 
216 library SafeMath {
217 
218     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
219         unchecked {
220             uint256 c = a + b;
221             if (c < a) return (false, 0);
222             return (true, c);
223         }
224     }
225 
226     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b > a) return (false, 0);
229             return (true, a - b);
230         }
231     }
232 
233     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         unchecked {
235             if (a == 0) return (true, 0);
236             uint256 c = a * b;
237             if (c / a != b) return (false, 0);
238             return (true, c);
239         }
240     }
241 
242     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
243         unchecked {
244             if (b == 0) return (false, 0);
245             return (true, a / b);
246         }
247     }
248 
249     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b == 0) return (false, 0);
252             return (true, a % b);
253         }
254     }
255 
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a + b;
258     }
259 
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a - b;
262     }
263 
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a * b;
266     }
267 
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a / b;
270     }
271 
272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a % b;
274     }
275 
276     function sub(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         unchecked {
282             require(b <= a, errorMessage);
283             return a - b;
284         }
285     }
286 
287     function div(
288         uint256 a,
289         uint256 b,
290         string memory errorMessage
291     ) internal pure returns (uint256) {
292         unchecked {
293             require(b > 0, errorMessage);
294             return a / b;
295         }
296     }
297 
298     function mod(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         unchecked {
304             require(b > 0, errorMessage);
305             return a % b;
306         }
307     }
308 }
309 
310 interface IUniswapV2Factory {
311     event PairCreated(
312         address indexed token0,
313         address indexed token1,
314         address pair,
315         uint256
316     );
317 
318     function feeTo() external view returns (address);
319 
320     function feeToSetter() external view returns (address);
321 
322     function getPair(address tokenA, address tokenB)
323         external
324         view
325         returns (address pair);
326 
327     function allPairs(uint256) external view returns (address pair);
328 
329     function allPairsLength() external view returns (uint256);
330 
331     function createPair(address tokenA, address tokenB)
332         external
333         returns (address pair);
334 
335     function setFeeTo(address) external;
336 
337     function setFeeToSetter(address) external;
338 }
339 
340 interface IUniswapV2Pair {
341     event Approval(
342         address indexed owner,
343         address indexed spender,
344         uint256 value
345     );
346     event Transfer(address indexed from, address indexed to, uint256 value);
347 
348     function name() external pure returns (string memory);
349 
350     function symbol() external pure returns (string memory);
351 
352     function decimals() external pure returns (uint8);
353 
354     function totalSupply() external view returns (uint256);
355 
356     function balanceOf(address owner) external view returns (uint256);
357 
358     function allowance(address owner, address spender)
359         external
360         view
361         returns (uint256);
362 
363     function approve(address spender, uint256 value) external returns (bool);
364 
365     function transfer(address to, uint256 value) external returns (bool);
366 
367     function transferFrom(
368         address from,
369         address to,
370         uint256 value
371     ) external returns (bool);
372 
373     function DOMAIN_SEPARATOR() external view returns (bytes32);
374 
375     function PERMIT_TYPEHASH() external pure returns (bytes32);
376 
377     function nonces(address owner) external view returns (uint256);
378 
379     function permit(
380         address owner,
381         address spender,
382         uint256 value,
383         uint256 deadline,
384         uint8 v,
385         bytes32 r,
386         bytes32 s
387     ) external;
388 
389     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
390 
391     event Swap(
392         address indexed sender,
393         uint256 amount0In,
394         uint256 amount1In,
395         uint256 amount0Out,
396         uint256 amount1Out,
397         address indexed to
398     );
399     event Sync(uint112 reserve0, uint112 reserve1);
400 
401     function MINIMUM_LIQUIDITY() external pure returns (uint256);
402 
403     function factory() external view returns (address);
404 
405     function token0() external view returns (address);
406 
407     function token1() external view returns (address);
408 
409     function getReserves()
410         external
411         view
412         returns (
413             uint112 reserve0,
414             uint112 reserve1,
415             uint32 blockTimestampLast
416         );
417 
418     function price0CumulativeLast() external view returns (uint256);
419 
420     function price1CumulativeLast() external view returns (uint256);
421 
422     function kLast() external view returns (uint256);
423 
424     function mint(address to) external returns (uint256 liquidity);
425 
426     function swap(
427         uint256 amount0Out,
428         uint256 amount1Out,
429         address to,
430         bytes calldata data
431     ) external;
432 
433     function skim(address to) external;
434 
435     function sync() external;
436 
437     function initialize(address, address) external;
438 }
439 
440 interface IUniswapV2Router02 {
441     function factory() external pure returns (address);
442 
443     function WETH() external pure returns (address);
444 
445     function addLiquidity(
446         address tokenA,
447         address tokenB,
448         uint256 amountADesired,
449         uint256 amountBDesired,
450         uint256 amountAMin,
451         uint256 amountBMin,
452         address to,
453         uint256 deadline
454     )
455         external
456         returns (
457             uint256 amountA,
458             uint256 amountB,
459             uint256 liquidity
460         );
461 
462     function addLiquidityETH(
463         address token,
464         uint256 amountTokenDesired,
465         uint256 amountTokenMin,
466         uint256 amountETHMin,
467         address to,
468         uint256 deadline
469     )
470         external
471         payable
472         returns (
473             uint256 amountToken,
474             uint256 amountETH,
475             uint256 liquidity
476         );
477 
478     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
479         uint256 amountIn,
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external;
485 
486     function swapExactETHForTokensSupportingFeeOnTransferTokens(
487         uint256 amountOutMin,
488         address[] calldata path,
489         address to,
490         uint256 deadline
491     ) external payable;
492 
493     function swapExactTokensForETHSupportingFeeOnTransferTokens(
494         uint256 amountIn,
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external;
500 }
501 
502 contract BoysClub is ERC20, Ownable {
503     using SafeMath for uint256;
504 
505     IUniswapV2Router02 public immutable uniswapV2Router;
506     address public immutable uniswapV2Pair;
507     address public constant deadAddress = address(0xdead);
508 
509     bool private swapping;
510 
511     address public marketingWallet;
512 
513     uint256 public maxTransactionAmount;
514     uint256 public swapTokensAtAmount;
515     uint256 public maxWallet;
516 
517     bool public tradingActive = false;
518     bool public swapEnabled = false;
519 
520     uint256 public buyTotalFees;
521     uint256 private buyMarketingFee;
522     uint256 private buyLiquidityFee;
523 
524     uint256 public sellTotalFees;
525     uint256 private sellMarketingFee;
526     uint256 private sellLiquidityFee;
527 
528     uint256 private tokensForMarketing;
529     uint256 private tokensForLiquidity;
530     uint256 private previousFee;
531 
532     mapping(address => bool) private _isExcludedFromFees;
533     mapping(address => bool) private _isExcludedMaxTransactionAmount;
534     mapping(address => bool) private automatedMarketMakerPairs;
535     mapping(address => bool) public bots;
536     mapping (address => uint256) public _buyMap;
537     event UpdateUniswapV2Router(
538         address indexed newAddress,
539         address indexed oldAddress
540     );
541 
542     event ExcludeFromFees(address indexed account, bool isExcluded);
543 
544     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
545 
546     event marketingWalletUpdated(
547         address indexed newWallet,
548         address indexed oldWallet
549     );
550 
551     event SwapAndLiquify(
552         uint256 tokensSwapped,
553         uint256 ethReceived,
554         uint256 tokensIntoLiquidity
555     );
556 
557     constructor() ERC20("Boys Club", "BC") {
558         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
559             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
560         );
561 
562         excludeFromMaxTransaction(address(_uniswapV2Router), true);
563         uniswapV2Router = _uniswapV2Router;
564 
565         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
566             .createPair(address(this), _uniswapV2Router.WETH());
567         excludeFromMaxTransaction(address(uniswapV2Pair), true);
568         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
569 
570         uint256 _buyMarketingFee = 5;
571         uint256 _buyLiquidityFee = 0;
572 
573         uint256 _sellMarketingFee = 70;
574         uint256 _sellLiquidityFee = 0;
575 
576         uint256 totalSupply = 1000000000 * 1e18;
577 
578         maxTransactionAmount = 10000000 * 1e18;
579         maxWallet = 10000000 * 1e18;
580         swapTokensAtAmount = (totalSupply * 1) / 1000;
581 
582         buyMarketingFee = _buyMarketingFee;
583         buyLiquidityFee = _buyLiquidityFee;
584         buyTotalFees = buyMarketingFee + buyLiquidityFee;
585 
586         sellMarketingFee = _sellMarketingFee;
587         sellLiquidityFee = _sellLiquidityFee;
588         sellTotalFees = sellMarketingFee + sellLiquidityFee;
589         previousFee = sellTotalFees;
590 
591         marketingWallet = address(0x009B8860d7B7500326342967c9d8fDD7F2cA12eE);
592 
593         excludeFromFees(owner(), true);
594         excludeFromFees(address(this), true);
595         excludeFromFees(address(0xdead), true);
596 
597         excludeFromMaxTransaction(owner(), true);
598         excludeFromMaxTransaction(address(this), true);
599         excludeFromMaxTransaction(address(0xdead), true);
600 
601         _mint(msg.sender, totalSupply);
602     }
603 
604     receive() external payable {}
605 
606     function enableTrading() external onlyOwner {
607         tradingActive = true;
608         swapEnabled = true;
609     }
610 
611     function updateSwapTokensAtAmount(uint256 newAmount)
612         external
613         onlyOwner
614         returns (bool)
615     {
616         require(
617             newAmount >= (totalSupply() * 1) / 100000,
618             "Swap amount cannot be lower than 0.001% total supply."
619         );
620         require(
621             newAmount <= (totalSupply() * 5) / 1000,
622             "Swap amount cannot be higher than 0.5% total supply."
623         );
624         swapTokensAtAmount = newAmount;
625         return true;
626     }
627 
628     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
629         require(
630             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
631             "Cannot set maxTxn lower than 0.5%"
632         );
633         require(
634             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
635             "Cannot set maxWallet lower than 0.5%"
636         );
637         maxWallet = newMaxWalletNum * (10**18);
638         maxTransactionAmount = newTxnNum * (10**18);
639     }
640 
641     function blockBots(address[] memory bots_) public onlyOwner {
642         for (uint256 i = 0; i < bots_.length; i++) {
643             bots[bots_[i]] = true;
644         }
645     }
646 
647     function unblockBot(address notbot) public onlyOwner {
648         bots[notbot] = false;
649     }
650 
651     function excludeFromMaxTransaction(address updAds, bool isEx)
652         public
653         onlyOwner
654     {
655         _isExcludedMaxTransactionAmount[updAds] = isEx;
656     }
657 
658     function updateBuyFees(
659         uint256 _marketingFee,
660         uint256 _liquidityFee
661     ) external onlyOwner {
662         buyMarketingFee = _marketingFee;
663         buyLiquidityFee = _liquidityFee;
664         buyTotalFees = buyMarketingFee + buyLiquidityFee;
665         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
666     }
667 
668     function updateSellFees(
669         uint256 _marketingFee,
670         uint256 _liquidityFee
671     ) external onlyOwner {
672         sellMarketingFee = _marketingFee;
673         sellLiquidityFee = _liquidityFee;
674         sellTotalFees = sellMarketingFee + sellLiquidityFee;
675         previousFee = sellTotalFees;
676         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
677     }
678 
679     function excludeFromFees(address account, bool excluded) public onlyOwner {
680         _isExcludedFromFees[account] = excluded;
681         emit ExcludeFromFees(account, excluded);
682     }
683 
684     function setAutomatedMarketMakerPair(address pair, bool value)
685         public
686         onlyOwner
687     {
688         require(
689             pair != uniswapV2Pair,
690             "The pair cannot be removed from automatedMarketMakerPairs"
691         );
692 
693         _setAutomatedMarketMakerPair(pair, value);
694     }
695 
696     function _setAutomatedMarketMakerPair(address pair, bool value) private {
697         automatedMarketMakerPairs[pair] = value;
698 
699         emit SetAutomatedMarketMakerPair(pair, value);
700     }
701 
702     function isExcludedFromFees(address account) public view returns (bool) {
703         return _isExcludedFromFees[account];
704     }
705 
706     function _transfer(
707         address from,
708         address to,
709         uint256 amount
710     ) internal override {
711         require(from != address(0), "ERC20: transfer from the zero address");
712         require(to != address(0), "ERC20: transfer to the zero address");
713 
714         if (amount == 0) {
715             super._transfer(from, to, 0);
716             return;
717         }
718 
719                 if (
720                 from != owner() &&
721                 to != owner() &&
722                 to != address(0) &&
723                 to != address(0xdead) &&
724                 !swapping
725             ) {
726                 if (!tradingActive) {
727                     require(
728                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
729                         "Trading is not active."
730                     );
731                 }
732                 
733                 require(!bots[from] && !bots[to], "Your account is blacklisted!");
734 
735                 //when buy
736                 if (
737                     automatedMarketMakerPairs[from] &&
738                     !_isExcludedMaxTransactionAmount[to]
739                 ) {
740                     require(
741                         amount <= maxTransactionAmount,
742                         "Buy transfer amount exceeds the maxTransactionAmount."
743                     );
744                     require(
745                         amount + balanceOf(to) <= maxWallet,
746                         "Max wallet exceeded"
747                     );
748                 }
749                 //when sell
750                 else if (
751                     automatedMarketMakerPairs[to] &&
752                     !_isExcludedMaxTransactionAmount[from]
753                 ) {
754                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
755                 } 
756                 
757                 else if (!_isExcludedMaxTransactionAmount[to]) {
758                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
759                 }
760             }
761 
762         uint256 contractTokenBalance = balanceOf(address(this));
763 
764         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
765 
766         if (
767             canSwap &&
768             swapEnabled &&
769             !swapping &&
770             !automatedMarketMakerPairs[from] &&
771             !_isExcludedFromFees[from] &&
772             !_isExcludedFromFees[to]
773         ) {
774             swapping = true;
775 
776             swapBack();
777 
778             swapping = false;
779         }
780 
781         bool takeFee = !swapping;
782 
783         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
784             takeFee = false;
785         }
786 
787         uint256 fees = 0;
788 
789         if (takeFee) {
790             // on sell
791             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
792                 fees = amount.mul(sellTotalFees).div(100);
793                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
794                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
795             }
796             // on buy
797             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
798                 fees = amount.mul(buyTotalFees).div(100);
799                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
800                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
801             }
802 
803             if (fees > 0) {
804                 super._transfer(from, address(this), fees);
805             }
806 
807             amount -= fees;
808         }
809 
810         super._transfer(from, to, amount);
811         sellTotalFees = previousFee;
812 
813     }
814 
815     function swapTokensForEth(uint256 tokenAmount) private {
816 
817         address[] memory path = new address[](2);
818         path[0] = address(this);
819         path[1] = uniswapV2Router.WETH();
820 
821         _approve(address(this), address(uniswapV2Router), tokenAmount);
822 
823         // make the swap
824         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
825             tokenAmount,
826             0,
827             path,
828             address(this),
829             block.timestamp
830         );
831     }
832 
833     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
834 
835         _approve(address(this), address(uniswapV2Router), tokenAmount);
836 
837         uniswapV2Router.addLiquidityETH{value: ethAmount}(
838             address(this),
839             tokenAmount,
840             0,
841             0,
842             deadAddress,
843             block.timestamp
844         );
845     }
846 
847     function swapBack() private {
848         uint256 contractBalance = balanceOf(address(this));
849         uint256 totalTokensToSwap = tokensForLiquidity +
850             tokensForMarketing;
851         bool success;
852 
853         if (contractBalance == 0 || totalTokensToSwap == 0) {
854             return;
855         }
856 
857         if (contractBalance > swapTokensAtAmount * 20) {
858             contractBalance = swapTokensAtAmount * 20;
859         }
860 
861         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
862             totalTokensToSwap /
863             2;
864         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
865 
866         uint256 initialETHBalance = address(this).balance;
867 
868         swapTokensForEth(amountToSwapForETH);
869 
870         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
871 
872         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
873             totalTokensToSwap
874         );
875 
876         uint256 ethForLiquidity = ethBalance - ethForMarketing;
877 
878         tokensForLiquidity = 0;
879         tokensForMarketing = 0;
880 
881         if (liquidityTokens > 0 && ethForLiquidity > 0) {
882             addLiquidity(liquidityTokens, ethForLiquidity);
883             emit SwapAndLiquify(
884                 amountToSwapForETH,
885                 ethForLiquidity,
886                 tokensForLiquidity
887             );
888         }
889 
890         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
891     }
892 }