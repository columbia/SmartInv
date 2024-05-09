1 /**
2 
3 Website: https://thisisnotalpha.com/
4 TG:      https://t.me/ThisIsNotAlphaOfficial
5 Twitter: https://twitter.com/ThisIsNotAlpha_
6 
7 ThisIsNotACasino.com (http://thisisnotacasino.com/) is a fully functional casino 
8 where users can play BlackJack, Roulette, Heads or Tails ,Poker, Baccarat, 
9 Slots, and many more games to win crypto!
10 
11 ThisIsNotACasino is a ThisIsNotAlpha.com (http://thisisnotalpha.com/) utility.
12 Taxes from the casino token will be used to buyback and add liquidity to $TINA. 
13 $TINA contract is 0x96beaA1316f85fD679ec49e5A63DaCc293B044be
14 
15 **/
16 // SPDX-License-Identifier: MIT
17 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
18 pragma experimental ABIEncoderV2;
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
35     constructor() {
36         _transferOwnership(_msgSender());
37     }
38 
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _transferOwnership(newOwner);
55     }
56 
57     function _transferOwnership(address newOwner) internal virtual {
58         address oldOwner = _owner;
59         _owner = newOwner;
60         emit OwnershipTransferred(oldOwner, newOwner);
61     }
62 }
63 
64 interface IERC20 {
65 
66     function totalSupply() external view returns (uint256);
67 
68     function balanceOf(address account) external view returns (uint256);
69 
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface IERC20Metadata is IERC20 {
88 
89     function name() external view returns (string memory);
90 
91     function symbol() external view returns (string memory);
92 
93     function decimals() external view returns (uint8);
94 }
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
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114 
115     function symbol() public view virtual override returns (string memory) {
116         return _symbol;
117     }
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     function totalSupply() public view virtual override returns (uint256) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address account) public view virtual override returns (uint256) {
128         return _balances[account];
129     }
130 
131     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
132         _transfer(_msgSender(), recipient, amount);
133         return true;
134     }
135 
136     function allowance(address owner, address spender) public view virtual override returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount) public virtual override returns (bool) {
141         _approve(_msgSender(), spender, amount);
142         return true;
143     }
144 
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) public virtual override returns (bool) {
150         _transfer(sender, recipient, amount);
151 
152         uint256 currentAllowance = _allowances[sender][_msgSender()];
153         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
154         unchecked {
155             _approve(sender, _msgSender(), currentAllowance - amount);
156         }
157 
158         return true;
159     }
160 
161     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
162         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
163         return true;
164     }
165 
166     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
167         uint256 currentAllowance = _allowances[_msgSender()][spender];
168         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
169         unchecked {
170             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
171         }
172 
173         return true;
174     }
175 
176     function _transfer(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) internal virtual {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183 
184         _beforeTokenTransfer(sender, recipient, amount);
185 
186         uint256 senderBalance = _balances[sender];
187         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
188         unchecked {
189             _balances[sender] = senderBalance - amount;
190         }
191         _balances[recipient] += amount;
192 
193         emit Transfer(sender, recipient, amount);
194 
195         _afterTokenTransfer(sender, recipient, amount);
196     }
197 
198     function _mint(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: mint to the zero address");
200 
201         _beforeTokenTransfer(address(0), account, amount);
202 
203         _totalSupply += amount;
204         _balances[account] += amount;
205         emit Transfer(address(0), account, amount);
206 
207         _afterTokenTransfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         uint256 accountBalance = _balances[account];
216         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
217         unchecked {
218             _balances[account] = accountBalance - amount;
219         }
220         _totalSupply -= amount;
221 
222         emit Transfer(account, address(0), amount);
223 
224         _afterTokenTransfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _beforeTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 
245     function _afterTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 }
251 
252 library SafeMath {
253 
254     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             uint256 c = a + b;
257             if (c < a) return (false, 0);
258             return (true, c);
259         }
260     }
261 
262     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b > a) return (false, 0);
265             return (true, a - b);
266         }
267     }
268 
269     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (a == 0) return (true, 0);
272             uint256 c = a * b;
273             if (c / a != b) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a / b);
282         }
283     }
284 
285     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a % b);
289         }
290     }
291 
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a + b;
294     }
295 
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a - b;
298     }
299 
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a * b;
302     }
303 
304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a / b;
306     }
307 
308     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a % b;
310     }
311 
312     function sub(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b <= a, errorMessage);
319             return a - b;
320         }
321     }
322 
323     function div(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a / b;
331         }
332     }
333 
334     function mod(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a % b;
342         }
343     }
344 }
345 
346 interface IUniswapV2Factory {
347     event PairCreated(
348         address indexed token0,
349         address indexed token1,
350         address pair,
351         uint256
352     );
353 
354     function feeTo() external view returns (address);
355 
356     function feeToSetter() external view returns (address);
357 
358     function getPair(address tokenA, address tokenB)
359         external
360         view
361         returns (address pair);
362 
363     function allPairs(uint256) external view returns (address pair);
364 
365     function allPairsLength() external view returns (uint256);
366 
367     function createPair(address tokenA, address tokenB)
368         external
369         returns (address pair);
370 
371     function setFeeTo(address) external;
372 
373     function setFeeToSetter(address) external;
374 }
375 
376 interface IUniswapV2Pair {
377     event Approval(
378         address indexed owner,
379         address indexed spender,
380         uint256 value
381     );
382     event Transfer(address indexed from, address indexed to, uint256 value);
383 
384     function name() external pure returns (string memory);
385 
386     function symbol() external pure returns (string memory);
387 
388     function decimals() external pure returns (uint8);
389 
390     function totalSupply() external view returns (uint256);
391 
392     function balanceOf(address owner) external view returns (uint256);
393 
394     function allowance(address owner, address spender)
395         external
396         view
397         returns (uint256);
398 
399     function approve(address spender, uint256 value) external returns (bool);
400 
401     function transfer(address to, uint256 value) external returns (bool);
402 
403     function transferFrom(
404         address from,
405         address to,
406         uint256 value
407     ) external returns (bool);
408 
409     function DOMAIN_SEPARATOR() external view returns (bytes32);
410 
411     function PERMIT_TYPEHASH() external pure returns (bytes32);
412 
413     function nonces(address owner) external view returns (uint256);
414 
415     function permit(
416         address owner,
417         address spender,
418         uint256 value,
419         uint256 deadline,
420         uint8 v,
421         bytes32 r,
422         bytes32 s
423     ) external;
424 
425     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
426     event Burn(
427         address indexed sender,
428         uint256 amount0,
429         uint256 amount1,
430         address indexed to
431     );
432     event Swap(
433         address indexed sender,
434         uint256 amount0In,
435         uint256 amount1In,
436         uint256 amount0Out,
437         uint256 amount1Out,
438         address indexed to
439     );
440     event Sync(uint112 reserve0, uint112 reserve1);
441 
442     function MINIMUM_LIQUIDITY() external pure returns (uint256);
443 
444     function factory() external view returns (address);
445 
446     function token0() external view returns (address);
447 
448     function token1() external view returns (address);
449 
450     function getReserves()
451         external
452         view
453         returns (
454             uint112 reserve0,
455             uint112 reserve1,
456             uint32 blockTimestampLast
457         );
458 
459     function price0CumulativeLast() external view returns (uint256);
460 
461     function price1CumulativeLast() external view returns (uint256);
462 
463     function kLast() external view returns (uint256);
464 
465     function mint(address to) external returns (uint256 liquidity);
466 
467     function burn(address to)
468         external
469         returns (uint256 amount0, uint256 amount1);
470 
471     function swap(
472         uint256 amount0Out,
473         uint256 amount1Out,
474         address to,
475         bytes calldata data
476     ) external;
477 
478     function skim(address to) external;
479 
480     function sync() external;
481 
482     function initialize(address, address) external;
483 }
484 
485 interface IUniswapV2Router02 {
486     function factory() external pure returns (address);
487 
488     function WETH() external pure returns (address);
489 
490     function addLiquidity(
491         address tokenA,
492         address tokenB,
493         uint256 amountADesired,
494         uint256 amountBDesired,
495         uint256 amountAMin,
496         uint256 amountBMin,
497         address to,
498         uint256 deadline
499     )
500         external
501         returns (
502             uint256 amountA,
503             uint256 amountB,
504             uint256 liquidity
505         );
506 
507     function addLiquidityETH(
508         address token,
509         uint256 amountTokenDesired,
510         uint256 amountTokenMin,
511         uint256 amountETHMin,
512         address to,
513         uint256 deadline
514     )
515         external
516         payable
517         returns (
518             uint256 amountToken,
519             uint256 amountETH,
520             uint256 liquidity
521         );
522 
523     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
524         uint256 amountIn,
525         uint256 amountOutMin,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external;
530 
531     function swapExactETHForTokensSupportingFeeOnTransferTokens(
532         uint256 amountOutMin,
533         address[] calldata path,
534         address to,
535         uint256 deadline
536     ) external payable;
537 
538     function swapExactTokensForETHSupportingFeeOnTransferTokens(
539         uint256 amountIn,
540         uint256 amountOutMin,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external;
545 }
546 
547 contract ThisIsNotACasino is ERC20, Ownable {
548     using SafeMath for uint256;
549 
550     IUniswapV2Router02 public immutable uniswapV2Router;
551     address public immutable uniswapV2Pair;
552     address public constant deadAddress = address(0xdead);
553 
554     bool private swapping;
555 
556     address public marketingWallet;
557     address public devWallet;
558     address public liqWallet;
559     address public casinoWallet;
560 
561     uint256 public maxTransactionAmount;
562     uint256 public swapTokensAtAmount;
563     uint256 public maxWallet;
564 
565     bool public limitsInEffect = true;
566     bool public tradingActive = false;
567     bool public swapEnabled = false;
568 
569     // Anti-bot and anti-whale mappings and variables
570     mapping(address => uint256) private _holderLastTransferTimestamp;
571     bool public transferDelayEnabled = true;
572 
573     uint256 public buyTotalFees;
574     uint256 public buyMarketingFee;
575     uint256 public buyLiquidityFee;
576     uint256 public buyDevFee;
577     uint256 public buyCasinoFee;
578 
579     uint256 public sellTotalFees;
580     uint256 public sellMarketingFee;
581     uint256 public sellLiquidityFee;
582     uint256 public sellDevFee;
583     uint256 public sellCasinoFee;
584 
585     uint256 public tokensForMarketing;
586     uint256 public tokensForLiquidity;
587     uint256 public tokensForDev;
588     uint256 public tokensForCasino;
589 
590     mapping(address => bool) private _isExcludedFromFees;
591     mapping(address => bool) public _isExcludedMaxTransactionAmount;
592 
593     mapping(address => bool) public automatedMarketMakerPairs;
594 
595     event UpdateUniswapV2Router(
596         address indexed newAddress,
597         address indexed oldAddress
598     );
599 
600     event ExcludeFromFees(address indexed account, bool isExcluded);
601 
602     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
603 
604     event marketingWalletUpdated(
605         address indexed newWallet,
606         address indexed oldWallet
607     );
608 
609     event devWalletUpdated(
610         address indexed newWallet,
611         address indexed oldWallet
612     );
613 
614     event liqWalletUpdated(
615         address indexed newWallet,
616         address indexed oldWallet
617     );
618 
619     event casinoWalletUpdated(
620         address indexed newWallet,
621         address indexed oldWallet
622     );
623 
624     event SwapAndLiquify(
625         uint256 tokensSwapped,
626         uint256 ethReceived,
627         uint256 tokensIntoLiquidity
628     );
629 
630     constructor() ERC20("This Is Not A Casino", "TINAC") {
631         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
632 
633         excludeFromMaxTransaction(address(_uniswapV2Router), true);
634         uniswapV2Router = _uniswapV2Router;
635 
636         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
637             .createPair(address(this), _uniswapV2Router.WETH());
638         excludeFromMaxTransaction(address(uniswapV2Pair), true);
639         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
640 
641         uint256 _buyMarketingFee = 4;
642         uint256 _buyLiquidityFee = 4;
643         uint256 _buyDevFee = 4;
644         uint256 _buyCasinoFee = 3;
645 
646         uint256 _sellMarketingFee = 5;
647         uint256 _sellLiquidityFee = 15;
648         uint256 _sellDevFee = 5;
649         uint256 _sellCasinoFee = 5;
650 
651         uint256 totalSupply = 1_000_000 * 1e18;
652 
653         maxTransactionAmount = 20_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
654         maxWallet = 20_000 * 1e18; // 2% from total supply maxWallet
655         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
656 
657         buyMarketingFee = _buyMarketingFee;
658         buyLiquidityFee = _buyLiquidityFee;
659         buyDevFee = _buyDevFee;
660         buyCasinoFee = _buyCasinoFee;
661         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyCasinoFee;
662 
663         sellMarketingFee = _sellMarketingFee;
664         sellLiquidityFee = _sellLiquidityFee;
665         sellDevFee = _sellDevFee;
666         sellCasinoFee = _sellCasinoFee;
667         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellCasinoFee;
668 
669         marketingWallet = address(0x7C3d51E113cB99de38c2029a80Ad019013c1a957); 
670         devWallet = address(0x96F71160b01e692d968d3307d03Ce33F905881F2); 
671         liqWallet = address(0xaF8C37289CA7d42B1637cd71EBE125Cfec5f71fF); 
672         casinoWallet = address(0xFd5CCC8dA4C42592A7790e6ee4B035FE18a18Aba); //thisisnotacasino.eth
673 
674         // exclude from paying fees or having max transaction amount
675         excludeFromFees(owner(), true);
676         excludeFromFees(address(this), true);
677         excludeFromFees(address(0xdead), true);
678 
679         excludeFromMaxTransaction(owner(), true);
680         excludeFromMaxTransaction(address(this), true);
681         excludeFromMaxTransaction(address(0xdead), true);
682 
683         _mint(msg.sender, totalSupply);
684     }
685 
686     receive() external payable {}
687 
688     function enableTrading() external onlyOwner {
689         tradingActive = true;
690         swapEnabled = true;
691     }
692 
693     // remove limits after token is stable
694     function removeLimits() external onlyOwner returns (bool) {
695         limitsInEffect = false;
696         return true;
697     }
698 
699     // disable Transfer delay - cannot be reenabled
700     function disableTransferDelay() external onlyOwner returns (bool) {
701         transferDelayEnabled = false;
702         return true;
703     }
704 
705     // change the minimum amount of tokens to sell from fees
706     function updateSwapTokensAtAmount(uint256 newAmount)
707         external
708         onlyOwner
709         returns (bool)
710     {
711         require(
712             newAmount >= (totalSupply() * 1) / 100000,
713             "Swap amount cannot be lower than 0.001% total supply."
714         );
715         require(
716             newAmount <= (totalSupply() * 5) / 1000,
717             "Swap amount cannot be higher than 0.5% total supply."
718         );
719         swapTokensAtAmount = newAmount;
720         return true;
721     }
722 
723     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
724         require(
725             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
726             "Cannot set maxTransactionAmount lower than 0.1%"
727         );
728         maxTransactionAmount = newNum * (10**18);
729     }
730 
731     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
732         require(
733             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
734             "Cannot set maxWallet lower than 0.5%"
735         );
736         maxWallet = newNum * (10**18);
737     }
738 
739     function excludeFromMaxTransaction(address updAds, bool isEx)
740         public
741         onlyOwner
742     {
743         _isExcludedMaxTransactionAmount[updAds] = isEx;
744     }
745 
746     // only use to disable contract sales if absolutely necessary (emergency use only)
747     function updateSwapEnabled(bool enabled) external onlyOwner {
748         swapEnabled = enabled;
749     }
750 
751     function updateBuyFees(
752         uint256 _marketingFee,
753         uint256 _liquidityFee,
754         uint256 _devFee,
755         uint256 _casinoFee
756     ) external onlyOwner {
757         buyMarketingFee = _marketingFee;
758         buyLiquidityFee = _liquidityFee;
759         buyDevFee = _devFee;
760         buyCasinoFee = _casinoFee;
761         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyCasinoFee;
762         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
763     }
764 
765     function updateSellFees(
766         uint256 _marketingFee,
767         uint256 _liquidityFee,
768         uint256 _devFee,
769         uint256 _casinoFee
770     ) external onlyOwner {
771         sellMarketingFee = _marketingFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevFee = _devFee;
774         sellCasinoFee = _casinoFee;
775         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellCasinoFee;
776         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
777     }
778 
779     function excludeFromFees(address account, bool excluded) public onlyOwner {
780         _isExcludedFromFees[account] = excluded;
781         emit ExcludeFromFees(account, excluded);
782     }
783 
784     function setAutomatedMarketMakerPair(address pair, bool value)
785         public
786         onlyOwner
787     {
788         require(
789             pair != uniswapV2Pair,
790             "The pair cannot be removed from automatedMarketMakerPairs"
791         );
792 
793         _setAutomatedMarketMakerPair(pair, value);
794     }
795 
796     function _setAutomatedMarketMakerPair(address pair, bool value) private {
797         automatedMarketMakerPairs[pair] = value;
798 
799         emit SetAutomatedMarketMakerPair(pair, value);
800     }
801 
802     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
803         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
804         marketingWallet = newMarketingWallet;
805     }
806 
807     function updateDevWallet(address newWallet) external onlyOwner {
808         emit devWalletUpdated(newWallet, devWallet);
809         devWallet = newWallet;
810     }
811 
812     function updateCasinoWallet(address newWallet) external onlyOwner{
813         emit casinoWalletUpdated(newWallet, casinoWallet);
814         casinoWallet = newWallet;
815     }
816 
817     function updateLiqWallet(address newLiqWallet) external onlyOwner {
818         emit liqWalletUpdated(newLiqWallet, liqWallet);
819         liqWallet = newLiqWallet;
820     }
821 
822     function isExcludedFromFees(address account) public view returns (bool) {
823         return _isExcludedFromFees[account];
824     }
825 
826     event BoughtEarly(address indexed sniper);
827 
828     function _transfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal override {
833         require(from != address(0), "ERC20: transfer from the zero address");
834         require(to != address(0), "ERC20: transfer to the zero address");
835 
836         if (amount == 0) {
837             super._transfer(from, to, 0);
838             return;
839         }
840 
841         if (limitsInEffect) {
842             if (
843                 from != owner() &&
844                 to != owner() &&
845                 to != address(0) &&
846                 to != address(0xdead) &&
847                 !swapping
848             ) {
849                 if (!tradingActive) {
850                     require(
851                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
852                         "Trading is not active."
853                     );
854                 }
855 
856                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
857                 if (transferDelayEnabled) {
858                     if (
859                         to != owner() &&
860                         to != address(uniswapV2Router) &&
861                         to != address(uniswapV2Pair)
862                     ) {
863                         require(
864                             _holderLastTransferTimestamp[tx.origin] <
865                                 block.number,
866                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
867                         );
868                         _holderLastTransferTimestamp[tx.origin] = block.number;
869                     }
870                 }
871 
872                 //when buy
873                 if (
874                     automatedMarketMakerPairs[from] &&
875                     !_isExcludedMaxTransactionAmount[to]
876                 ) {
877                     require(
878                         amount <= maxTransactionAmount,
879                         "Buy transfer amount exceeds the maxTransactionAmount."
880                     );
881                     require(
882                         amount + balanceOf(to) <= maxWallet,
883                         "Max wallet exceeded"
884                     );
885                 }
886                 //when sell
887                 else if (
888                     automatedMarketMakerPairs[to] &&
889                     !_isExcludedMaxTransactionAmount[from]
890                 ) {
891                     require(
892                         amount <= maxTransactionAmount,
893                         "Sell transfer amount exceeds the maxTransactionAmount."
894                     );
895                 } else if (!_isExcludedMaxTransactionAmount[to]) {
896                     require(
897                         amount + balanceOf(to) <= maxWallet,
898                         "Max wallet exceeded"
899                     );
900                 }
901             }
902         }
903 
904         uint256 contractTokenBalance = balanceOf(address(this));
905 
906         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
907 
908         if (
909             canSwap &&
910             swapEnabled &&
911             !swapping &&
912             !automatedMarketMakerPairs[from] &&
913             !_isExcludedFromFees[from] &&
914             !_isExcludedFromFees[to]
915         ) {
916             swapping = true;
917 
918             swapBack();
919 
920             swapping = false;
921         }
922 
923         bool takeFee = !swapping;
924 
925         // if any account belongs to _isExcludedFromFee account then remove the fee
926         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
927             takeFee = false;
928         }
929 
930         uint256 fees = 0;
931         // only take fees on buys/sells, do not take on wallet transfers
932         if (takeFee) {
933             // on sell
934             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
935                 fees = amount.mul(sellTotalFees).div(100);
936                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
937                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
938                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
939                 tokensForCasino += (fees * sellCasinoFee) / sellTotalFees;
940             }
941             // on buy
942             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
943                 fees = amount.mul(buyTotalFees).div(100);
944                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
945                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
946                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
947                 tokensForCasino += (fees * buyCasinoFee) / buyTotalFees;
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
988             liqWallet,
989             block.timestamp
990         );
991     }
992 
993     function swapBack() private {
994         uint256 contractBalance = balanceOf(address(this));
995         uint256 totalTokensToSwap = tokensForLiquidity +
996             tokensForMarketing +
997             tokensForDev +
998             tokensForCasino;
999         bool success;
1000 
1001         if (contractBalance == 0 || totalTokensToSwap == 0) {
1002             return;
1003         }
1004 
1005         if (contractBalance > swapTokensAtAmount * 20) {
1006             contractBalance = swapTokensAtAmount * 20;
1007         }
1008 
1009         // Halve the amount of liquidity tokens
1010         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1011         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1012 
1013         uint256 initialETHBalance = address(this).balance;
1014 
1015         swapTokensForEth(amountToSwapForETH);
1016 
1017         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1018 
1019         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1020         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1021         uint256 ethForCasino = ethBalance.mul(tokensForCasino).div(totalTokensToSwap);
1022 
1023         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForCasino;
1024 
1025         tokensForLiquidity = 0;
1026         tokensForMarketing = 0;
1027         tokensForDev = 0;
1028         tokensForCasino = 0;
1029 
1030         (success, ) = address(devWallet).call{value: ethForDev}("");
1031 
1032         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1033             addLiquidity(liquidityTokens, ethForLiquidity);
1034             emit SwapAndLiquify(
1035                 amountToSwapForETH,
1036                 ethForLiquidity,
1037                 tokensForLiquidity
1038             );
1039         }
1040 
1041         (success, ) = address(casinoWallet).call{value: ethForCasino}("");
1042         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1043     }
1044 }