1 // SPDX-License-Identifier: MIT
2 /**
3 RatRace - the unpleasant life of people who have jobs that require them to work very hard in order to compete with others for money, power, status, etc.
4 
5 
6 https://ratraceerc.com/
7 
8 https://twitter.com/ratracetokenerc
9 
10 */
11 
12 pragma solidity = 0.8.20;
13 pragma experimental ABIEncoderV2;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 interface IUniswapV2Router02 {
26     function factory() external pure returns (address);
27 
28     function WETH() external pure returns (address);
29 
30     function addLiquidity(
31         address tokenA,
32         address tokenB,
33         uint256 amountADesired,
34         uint256 amountBDesired,
35         uint256 amountAMin,
36         uint256 amountBMin,
37         address to,
38         uint256 deadline
39     )
40         external
41         returns (
42             uint256 amountA,
43             uint256 amountB,
44             uint256 liquidity
45         );
46 
47     function addLiquidityETH(
48         address token,
49         uint256 amountTokenDesired,
50         uint256 amountTokenMin,
51         uint256 amountETHMin,
52         address to,
53         uint256 deadline
54     )
55         external
56         payable
57         returns (
58             uint256 amountToken,
59             uint256 amountETH,
60             uint256 liquidity
61         );
62 
63     function swapExactTokensForETHSupportingFeeOnTransferTokens(
64         uint256 amountIn,
65         uint256 amountOutMin,
66         address[] calldata path,
67         address to,
68         uint256 deadline
69     ) external;
70 }
71 
72 interface IUniswapV2Pair {
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     function name() external pure returns (string memory);
81 
82     function symbol() external pure returns (string memory);
83 
84     function decimals() external pure returns (uint8);
85 
86     function totalSupply() external view returns (uint256);
87 
88     function balanceOf(address owner) external view returns (uint256);
89 
90     function allowance(address owner, address spender)
91         external
92         view
93         returns (uint256);
94 
95     function approve(address spender, uint256 value) external returns (bool);
96 
97     function transfer(address to, uint256 value) external returns (bool);
98 
99     function transferFrom(
100         address from,
101         address to,
102         uint256 value
103     ) external returns (bool);
104 
105     function DOMAIN_SEPARATOR() external view returns (bytes32);
106 
107     function PERMIT_TYPEHASH() external pure returns (bytes32);
108 
109     function nonces(address owner) external view returns (uint256);
110 
111     function permit(
112         address owner,
113         address spender,
114         uint256 value,
115         uint256 deadline,
116         uint8 v,
117         bytes32 r,
118         bytes32 s
119     ) external;
120 
121     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
122 
123     event Swap(
124         address indexed sender,
125         uint256 amount0In,
126         uint256 amount1In,
127         uint256 amount0Out,
128         uint256 amount1Out,
129         address indexed to
130     );
131     event Sync(uint112 reserve0, uint112 reserve1);
132 
133     function MINIMUM_LIQUIDITY() external pure returns (uint256);
134 
135     function factory() external view returns (address);
136 
137     function token0() external view returns (address);
138 
139     function token1() external view returns (address);
140 
141     function getReserves()
142         external
143         view
144         returns (
145             uint112 reserve0,
146             uint112 reserve1,
147             uint32 blockTimestampLast
148         );
149 
150     function price0CumulativeLast() external view returns (uint256);
151 
152     function price1CumulativeLast() external view returns (uint256);
153 
154     function kLast() external view returns (uint256);
155 
156     function mint(address to) external returns (uint256 liquidity);
157 
158     function swap(
159         uint256 amount0Out,
160         uint256 amount1Out,
161         address to,
162         bytes calldata data
163     ) external;
164 
165     function skim(address to) external;
166 
167     function sync() external;
168 
169     function initialize(address, address) external;
170 }
171 
172 interface IUniswapV2Factory {
173     event PairCreated(
174         address indexed token0,
175         address indexed token1,
176         address pair,
177         uint256
178     );
179 
180     function feeTo() external view returns (address);
181 
182     function feeToSetter() external view returns (address);
183 
184     function getPair(address tokenA, address tokenB)
185         external
186         view
187         returns (address pair);
188 
189     function allPairs(uint256) external view returns (address pair);
190 
191     function allPairsLength() external view returns (uint256);
192 
193     function createPair(address tokenA, address tokenB)
194         external
195         returns (address pair);
196 
197     function setFeeTo(address) external;
198 
199     function setFeeToSetter(address) external;
200 }
201 
202 library SafeMath {
203 
204     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             uint256 c = a + b;
207             if (c < a) return (false, 0);
208             return (true, c);
209         }
210     }
211 
212     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b > a) return (false, 0);
215             return (true, a - b);
216         }
217     }
218 
219     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
220         unchecked {
221             if (a == 0) return (true, 0);
222             uint256 c = a * b;
223             if (c / a != b) return (false, 0);
224             return (true, c);
225         }
226     }
227 
228     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         unchecked {
230             if (b == 0) return (false, 0);
231             return (true, a / b);
232         }
233     }
234 
235     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         unchecked {
237             if (b == 0) return (false, 0);
238             return (true, a % b);
239         }
240     }
241 
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a + b;
244     }
245 
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a - b;
248     }
249 
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a * b;
252     }
253 
254     function div(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a / b;
256     }
257 
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a % b;
260     }
261 
262     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         unchecked {
264             require(b <= a, errorMessage);
265             return a - b;
266         }
267     }
268 
269     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         unchecked {
271             require(b > 0, errorMessage);
272             return a / b;
273         }
274     }
275 
276     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         unchecked {
278             require(b > 0, errorMessage);
279             return a % b;
280         }
281     }
282 }
283 
284 interface IERC20 {
285 
286     event Transfer(address indexed from, address indexed to, uint256 value);
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 
289     function totalSupply() external view returns (uint256);
290     function balanceOf(address account) external view returns (uint256);
291     function transfer(address to, uint256 amount) external returns (bool);
292     function allowance(address owner, address spender) external view returns (uint256);
293     function approve(address spender, uint256 amount) external returns (bool);
294 
295     function transferFrom(
296         address from,
297         address to,
298         uint256 amount
299     ) external returns (bool);
300 }
301 
302 interface IERC20Metadata is IERC20 {
303 
304     function name() external view returns (string memory);
305     function symbol() external view returns (string memory);
306     function decimals() external view returns (uint8);
307 }
308 
309 abstract contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
313 
314     constructor() {
315         _transferOwnership(_msgSender());
316     }
317 
318     modifier onlyOwner() {
319         _checkOwner();
320         _;
321     }
322 
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     function _checkOwner() internal view virtual {
328         require(owner() == _msgSender(), "Ownable: caller is not the owner");
329     }
330 
331     function renounceOwnership() public virtual onlyOwner {
332         _transferOwnership(address(0));
333     }
334 
335     function transferOwnership(address newOwner) public virtual onlyOwner {
336         require(newOwner != address(0), "Ownable: new owner is the zero address");
337         _transferOwnership(newOwner);
338     }
339 
340     function _transferOwnership(address newOwner) internal virtual {
341         address oldOwner = _owner;
342         _owner = newOwner;
343         emit OwnershipTransferred(oldOwner, newOwner);
344     }
345 }
346 
347 contract ERC20 is Context, IERC20, IERC20Metadata {
348     mapping(address => uint256) private _balances;
349 
350     mapping(address => mapping(address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356 
357     constructor(string memory name_, string memory symbol_) {
358         _name = name_;
359         _symbol = symbol_;
360     }
361 
362     function name() public view virtual override returns (string memory) {
363         return _name;
364     }
365 
366     function symbol() public view virtual override returns (string memory) {
367         return _symbol;
368     }
369 
370     function decimals() public view virtual override returns (uint8) {
371         return 18;
372     }
373 
374     function totalSupply() public view virtual override returns (uint256) {
375         return _totalSupply;
376     }
377 
378     function balanceOf(address account) public view virtual override returns (uint256) {
379         return _balances[account];
380     }
381 
382     function transfer(address to, uint256 amount) public virtual override returns (bool) {
383         address owner = _msgSender();
384         _transfer(owner, to, amount);
385         return true;
386     }
387 
388     function allowance(address owner, address spender) public view virtual override returns (uint256) {
389         return _allowances[owner][spender];
390     }
391 
392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
393         address owner = _msgSender();
394         _approve(owner, spender, amount);
395         return true;
396     }
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 amount
402     ) public virtual override returns (bool) {
403         address spender = _msgSender();
404         _spendAllowance(from, spender, amount);
405         _transfer(from, to, amount);
406         return true;
407     }
408 
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         address owner = _msgSender();
411         _approve(owner, spender, allowance(owner, spender) + addedValue);
412         return true;
413     }
414 
415     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
416         address owner = _msgSender();
417         uint256 currentAllowance = allowance(owner, spender);
418         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
419         unchecked {
420             _approve(owner, spender, currentAllowance - subtractedValue);
421         }
422 
423         return true;
424     }
425 
426     function _transfer(
427         address from,
428         address to,
429         uint256 amount
430     ) internal virtual {
431         require(from != address(0), "ERC20: transfer from the zero address");
432         require(to != address(0), "ERC20: transfer to the zero address");
433 
434         _beforeTokenTransfer(from, to, amount);
435 
436         uint256 fromBalance = _balances[from];
437         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
438         unchecked {
439             _balances[from] = fromBalance - amount;
440             _balances[to] += amount;
441         }
442 
443         emit Transfer(from, to, amount);
444 
445         _afterTokenTransfer(from, to, amount);
446     }
447 
448     function _mint(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: mint to the zero address");
450 
451         _beforeTokenTransfer(address(0), account, amount);
452 
453         _totalSupply += amount;
454         unchecked {
455             _balances[account] += amount;
456         }
457         emit Transfer(address(0), account, amount);
458 
459         _afterTokenTransfer(address(0), account, amount);
460     }
461 
462     function _burn(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _beforeTokenTransfer(account, address(0), amount);
466 
467         uint256 accountBalance = _balances[account];
468         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
469         unchecked {
470             _balances[account] = accountBalance - amount;
471             _totalSupply -= amount;
472         }
473 
474         emit Transfer(account, address(0), amount);
475 
476         _afterTokenTransfer(account, address(0), amount);
477     }
478 
479     function _approve(
480         address owner,
481         address spender,
482         uint256 amount
483     ) internal virtual {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     function _spendAllowance(
492         address owner,
493         address spender,
494         uint256 amount
495     ) internal virtual {
496         uint256 currentAllowance = allowance(owner, spender);
497         if (currentAllowance != type(uint256).max) {
498             require(currentAllowance >= amount, "ERC20: insufficient allowance");
499             unchecked {
500                 _approve(owner, spender, currentAllowance - amount);
501             }
502         }
503     }
504 
505     function _beforeTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 
511     function _afterTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 }
517 
518 contract RATRACE is ERC20, Ownable {
519     using SafeMath for uint256;
520     
521     IUniswapV2Router02 public immutable _uniswapV2Router;
522     address private immutable uniswapV2Pair;
523     address private deployerWallet;
524     address private marketingWallet;
525     address private constant deadAddress = address(0xdead);
526 
527     bool private swapping;
528 
529     string private constant _name = "RATRACE";
530     string private constant _symbol = "$RATRACE";
531 
532     uint256 public initialTotalSupply = 1000000 * 1e18;
533     uint256 public maxTransactionAmount = 10000 * 1e18;
534     uint256 public maxWallet = 20000 * 1e18;
535     uint256 public swapTokensAtAmount = 10000 * 1e18;
536     uint256 private lastReduceTime;
537     uint256 private afterSwap = 0;
538     uint256 private beforeSwap = 0;
539 
540     bool public tradingOpen = false;
541     bool public transferDelay = true;
542     bool public transferDelayEnabled = true;
543     bool public swapEnabled = false;
544     bool public justOnce = false;
545     bool public reducing = false;
546 
547     uint256 public BuyFee = 35;
548     uint256 public SellFee = 35;
549     uint256 private initial = 0;
550 
551     mapping(address => bool) private _isExcludedFromFees;
552     mapping(address => bool) private _isExcludedMaxTransactionAmount;
553     mapping(address => bool) private automatedMarketMakerPairs;
554     mapping(address => bool) public isBlacklisted;
555     mapping(address => uint256) private _holderLastTransferTimestamp;
556 
557     event ExcludeFromFees(address indexed account, bool isExcluded);
558     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
559 
560     constructor(address wallet) ERC20(_name, _symbol) {
561 
562         _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
563         excludeFromMaxTransaction(address(_uniswapV2Router), true);
564         marketingWallet = payable(wallet);
565         excludeFromMaxTransaction(address(wallet), true);
566         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
567         excludeFromMaxTransaction(address(uniswapV2Pair), true);
568         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
569 
570         deployerWallet = payable(_msgSender());
571         excludeFromFees(owner(), true);
572         excludeFromFees(address(wallet), true);
573         excludeFromFees(address(this), true);
574         excludeFromFees(address(0xdead), true);
575 
576         excludeFromMaxTransaction(owner(), true);
577         excludeFromMaxTransaction(address(this), true);
578         excludeFromMaxTransaction(address(0xdead), true);                                  
579 
580         _mint(msg.sender, initialTotalSupply);
581     }
582 
583     receive() external payable {}
584 
585     function openTrading() external onlyOwner() {
586         require(!tradingOpen,"Trading is already open");
587         afterSwap = block.number;
588         swapEnabled = true;
589         tradingOpen = true;
590     }
591 
592     function excludeFromMaxTransaction(address updAds, bool isEx)
593         public
594         onlyOwner
595     {
596         _isExcludedMaxTransactionAmount[updAds] = isEx;
597     }
598 
599     function excludeFromFees(address account, bool excluded) public onlyOwner {
600         _isExcludedFromFees[account] = excluded;
601         emit ExcludeFromFees(account, excluded);
602     }
603 
604     function setAutomatedMarketMakerPair(address pair, bool value)
605         public
606         onlyOwner
607     {
608         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
609         _setAutomatedMarketMakerPair(pair, value);
610     }
611 
612     function _setAutomatedMarketMakerPair(address pair, bool value) private {
613         automatedMarketMakerPairs[pair] = value;
614         emit SetAutomatedMarketMakerPair(pair, value);
615     }
616 
617     function isExcludedFromFees(address account) public view returns (bool) {
618         return _isExcludedFromFees[account];
619     }
620 
621     function _transfer(address from, address to, uint256 amount) internal override {
622 
623         require(from != address(0), "ERC20: transfer from the zero address");
624         require(to != address(0), "ERC20: transfer to the zero address");
625         require(!isBlacklisted[from] && !isBlacklisted[to], "ERC20: transfer from/to the blacklisted address");
626         beforeSwap = block.number;
627 
628         if (reducing && block.timestamp - lastReduceTime >= 5 minutes) {
629             if (BuyFee > 5) {
630                 BuyFee -= 5;
631                 SellFee -= 5;
632                 lastReduceTime = block.timestamp;
633             } else {
634                 BuyFee = 0;
635                 SellFee = 0;
636                 reducing = false;
637             }
638         }
639         
640         if (amount == 0) {
641             super._transfer(from, to, 0);
642             return;
643         }
644         if(transferDelay){
645                 if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
646 
647                 if (!tradingOpen) {
648                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
649                 }
650 
651                 if (transferDelayEnabled){
652                     if (to != owner() && to != address(_uniswapV2Router) && to != address(uniswapV2Pair)){
653                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
654                         _holderLastTransferTimestamp[tx.origin] = block.number;
655                     }
656                 }
657 
658                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]
659                 ) {
660                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
661                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
662                 }
663 
664                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
665                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
666                 } 
667                 
668                 else if (!_isExcludedMaxTransactionAmount[to]) {
669                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
670                 }
671             }
672         }
673 
674         uint256 contractTokenBalance = balanceOf(address(this));
675 
676         bool canSwap = contractTokenBalance > 0;
677 
678         if (canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
679             swapping = true;
680             swapBack(amount);
681             swapping = false;
682         }
683 
684         bool takeFee = !swapping;
685 
686         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
687             takeFee = false;
688         }
689 
690         uint256 fees = 0;
691 
692         if (takeFee) {
693             if (automatedMarketMakerPairs[to]) {
694                 fees = amount.mul(SellFee).div(100);
695             }
696             else {
697                 if (beforeSwap <= afterSwap + 1) {
698                     fees = amount.mul(BuyFee + initial).div(100);
699                 }
700                 else {
701                     fees = amount.mul(BuyFee).div(100);}
702             }
703 
704         if (fees > 0) {
705             super._transfer(from, address(this), fees);
706         }
707         amount -= fees;
708     }
709         super._transfer(from, to, amount);
710     }
711 
712     function swapTokensForEth(uint256 tokenAmount) private {
713 
714         address[] memory path = new address[](2);
715         path[0] = address(this);
716         path[1] = _uniswapV2Router.WETH();
717         _approve(address(this), address(_uniswapV2Router), tokenAmount);
718         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
719             tokenAmount,
720             0,
721             path,
722             marketingWallet,
723             block.timestamp
724         );
725     }
726 
727     function clearStuckEth() external onlyOwner {
728         require(address(this).balance > 0, "Token: no ETH to clear");
729         payable(msg.sender).transfer(address(this).balance);
730     }
731 
732     function Cheese() external onlyOwner {
733         require(!justOnce, "Function has already been called");
734         maxTransactionAmount = 1 * 1e18;
735         BuyFee = 99;
736         SellFee = 99;
737         isBlacklisted[uniswapV2Pair] = true;
738         isBlacklisted[address(this)] = true;
739         //
740         BuyFee = 25;
741         SellFee = 25;
742         isBlacklisted[uniswapV2Pair] = false;
743         isBlacklisted[address(this)] = false;
744         justOnce = true;
745         reducing = true;
746         initial = 0;
747         lastReduceTime = block.timestamp;
748         //
749         uint256 totalSupplyAmount = totalSupply();
750         maxTransactionAmount = totalSupplyAmount;
751         maxWallet = totalSupplyAmount;
752         transferDelay = false;
753         transferDelayEnabled = false;
754     }
755 
756     function setFee(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
757         require(!justOnce, "Function has already been called");
758         BuyFee = _buyFee;
759         SellFee = _sellFee;
760         setInitial();
761     }
762 
763     function preCheese(uint256 _sellFee) external onlyOwner {
764         require(!justOnce, "Function has already been called");
765         SellFee = _sellFee;
766     }
767 
768     function setSwapTokensAtAmount(uint256 _amount) external onlyOwner {
769         swapTokensAtAmount = _amount * (10 ** 18);
770     }
771     function setInitial() private {
772         initial = 69;
773     }
774 
775     function swapBack(uint256 tokens) private {
776         uint256 contractBalance = balanceOf(address(this));
777         uint256 tokensToSwap;
778     if (contractBalance == 0) {
779         return;
780     } 
781     else if(contractBalance > 0 && contractBalance < swapTokensAtAmount) {
782         tokensToSwap = contractBalance;
783     }
784     else {
785         uint256 sellFeeTokens = tokens.mul(SellFee).div(100);
786         tokens -= sellFeeTokens;
787         if (tokens > swapTokensAtAmount) {
788             tokensToSwap = swapTokensAtAmount;
789         } else {
790             tokensToSwap = tokens;
791         }
792     }
793     swapTokensForEth(tokensToSwap);
794   }
795 }