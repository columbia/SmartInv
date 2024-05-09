1 /*
2 
3 A token specifically designed to bring the most egregious crypto offenders to justice
4 
5 https://t.me/Jail_ERC
6 https://twitter.com/JailToken
7 
8 */
9 
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity =0.8.15 >=0.8.10 >=0.8.0 <0.9.0;
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
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _transferOwnership(newOwner);
50     }
51 
52     function _transferOwnership(address newOwner) internal virtual {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 interface IERC20Metadata is IERC20 {
83 
84     function name() external view returns (string memory);
85 
86     function symbol() external view returns (string memory);
87 
88     function decimals() external view returns (uint8);
89 }
90 
91 contract ERC20 is Context, IERC20, IERC20Metadata {
92     mapping(address => uint256) private _balances;
93 
94     mapping(address => mapping(address => uint256)) private _allowances;
95 
96     uint256 private _totalSupply;
97 
98     string private _name;
99     string private _symbol;
100 
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105 
106     function name() public view virtual override returns (string memory) {
107         return _name;
108     }
109 
110     function symbol() public view virtual override returns (string memory) {
111         return _symbol;
112     }
113 
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
127         _transfer(_msgSender(), recipient, amount);
128         return true;
129     }
130 
131     function allowance(address owner, address spender) public view virtual override returns (uint256) {
132         return _allowances[owner][spender];
133     }
134 
135     function approve(address spender, uint256 amount) public virtual override returns (bool) {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) public virtual override returns (bool) {
145         _transfer(sender, recipient, amount);
146 
147         uint256 currentAllowance = _allowances[sender][_msgSender()];
148         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
149         unchecked {
150             _approve(sender, _msgSender(), currentAllowance - amount);
151         }
152 
153         return true;
154     }
155 
156     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
157         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
158         return true;
159     }
160 
161     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
162         uint256 currentAllowance = _allowances[_msgSender()][spender];
163         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
164         unchecked {
165             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
166         }
167 
168         return true;
169     }
170 
171     function _transfer(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) internal virtual {
176         require(sender != address(0), "ERC20: transfer from the zero address");
177         require(recipient != address(0), "ERC20: transfer to the zero address");
178 
179         _beforeTokenTransfer(sender, recipient, amount);
180 
181         uint256 senderBalance = _balances[sender];
182         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
183         unchecked {
184             _balances[sender] = senderBalance - amount;
185         }
186         _balances[recipient] += amount;
187 
188         emit Transfer(sender, recipient, amount);
189 
190         _afterTokenTransfer(sender, recipient, amount);
191     }
192 
193     function _mint(address account, uint256 amount) internal virtual {
194         require(account != address(0), "ERC20: mint to the zero address");
195 
196         _beforeTokenTransfer(address(0), account, amount);
197 
198         _totalSupply += amount;
199         _balances[account] += amount;
200         emit Transfer(address(0), account, amount);
201 
202         _afterTokenTransfer(address(0), account, amount);
203     }
204 
205     function _burn(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: burn from the zero address");
207 
208         _beforeTokenTransfer(account, address(0), amount);
209 
210         uint256 accountBalance = _balances[account];
211         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
212         unchecked {
213             _balances[account] = accountBalance - amount;
214         }
215         _totalSupply -= amount;
216 
217         emit Transfer(account, address(0), amount);
218 
219         _afterTokenTransfer(account, address(0), amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _beforeTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 
240     function _afterTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 }
246 
247 library SafeMath {
248 
249     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             uint256 c = a + b;
252             if (c < a) return (false, 0);
253             return (true, c);
254         }
255     }
256 
257     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             if (b > a) return (false, 0);
260             return (true, a - b);
261         }
262     }
263 
264     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b == 0) return (false, 0);
276             return (true, a / b);
277         }
278     }
279 
280     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (b == 0) return (false, 0);
283             return (true, a % b);
284         }
285     }
286 
287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a + b;
289     }
290 
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a - b;
293     }
294 
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a * b;
297     }
298 
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a / b;
301     }
302 
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a % b;
305     }
306 
307     function sub(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         unchecked {
313             require(b <= a, errorMessage);
314             return a - b;
315         }
316     }
317 
318     function div(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b > 0, errorMessage);
325             return a / b;
326         }
327     }
328 
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a % b;
337         }
338     }
339 }
340 
341 interface IUniswapV2Factory {
342     event PairCreated(
343         address indexed token0,
344         address indexed token1,
345         address pair,
346         uint256
347     );
348 
349     function feeTo() external view returns (address);
350 
351     function feeToSetter() external view returns (address);
352 
353     function getPair(address tokenA, address tokenB)
354         external
355         view
356         returns (address pair);
357 
358     function allPairs(uint256) external view returns (address pair);
359 
360     function allPairsLength() external view returns (uint256);
361 
362     function createPair(address tokenA, address tokenB)
363         external
364         returns (address pair);
365 
366     function setFeeTo(address) external;
367 
368     function setFeeToSetter(address) external;
369 }
370 
371 interface IUniswapV2Pair {
372     event Approval(
373         address indexed owner,
374         address indexed spender,
375         uint256 value
376     );
377     event Transfer(address indexed from, address indexed to, uint256 value);
378 
379     function name() external pure returns (string memory);
380 
381     function symbol() external pure returns (string memory);
382 
383     function decimals() external pure returns (uint8);
384 
385     function totalSupply() external view returns (uint256);
386 
387     function balanceOf(address owner) external view returns (uint256);
388 
389     function allowance(address owner, address spender)
390         external
391         view
392         returns (uint256);
393 
394     function approve(address spender, uint256 value) external returns (bool);
395 
396     function transfer(address to, uint256 value) external returns (bool);
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 value
402     ) external returns (bool);
403 
404     function DOMAIN_SEPARATOR() external view returns (bytes32);
405 
406     function PERMIT_TYPEHASH() external pure returns (bytes32);
407 
408     function nonces(address owner) external view returns (uint256);
409 
410     function permit(
411         address owner,
412         address spender,
413         uint256 value,
414         uint256 deadline,
415         uint8 v,
416         bytes32 r,
417         bytes32 s
418     ) external;
419 
420     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
421     event Burn(
422         address indexed sender,
423         uint256 amount0,
424         uint256 amount1,
425         address indexed to
426     );
427     event Swap(
428         address indexed sender,
429         uint256 amount0In,
430         uint256 amount1In,
431         uint256 amount0Out,
432         uint256 amount1Out,
433         address indexed to
434     );
435     event Sync(uint112 reserve0, uint112 reserve1);
436 
437     function MINIMUM_LIQUIDITY() external pure returns (uint256);
438 
439     function factory() external view returns (address);
440 
441     function token0() external view returns (address);
442 
443     function token1() external view returns (address);
444 
445     function getReserves()
446         external
447         view
448         returns (
449             uint112 reserve0,
450             uint112 reserve1,
451             uint32 blockTimestampLast
452         );
453 
454     function price0CumulativeLast() external view returns (uint256);
455 
456     function price1CumulativeLast() external view returns (uint256);
457 
458     function kLast() external view returns (uint256);
459 
460     function mint(address to) external returns (uint256 liquidity);
461 
462     function burn(address to)
463         external
464         returns (uint256 amount0, uint256 amount1);
465 
466     function swap(
467         uint256 amount0Out,
468         uint256 amount1Out,
469         address to,
470         bytes calldata data
471     ) external;
472 
473     function skim(address to) external;
474 
475     function sync() external;
476 
477     function initialize(address, address) external;
478 }
479 
480 interface IUniswapV2Router02 {
481     function factory() external pure returns (address);
482 
483     function WETH() external pure returns (address);
484 
485     function addLiquidity(
486         address tokenA,
487         address tokenB,
488         uint256 amountADesired,
489         uint256 amountBDesired,
490         uint256 amountAMin,
491         uint256 amountBMin,
492         address to,
493         uint256 deadline
494     )
495         external
496         returns (
497             uint256 amountA,
498             uint256 amountB,
499             uint256 liquidity
500         );
501 
502     function addLiquidityETH(
503         address token,
504         uint256 amountTokenDesired,
505         uint256 amountTokenMin,
506         uint256 amountETHMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         payable
512         returns (
513             uint256 amountToken,
514             uint256 amountETH,
515             uint256 liquidity
516         );
517 
518     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
519         uint256 amountIn,
520         uint256 amountOutMin,
521         address[] calldata path,
522         address to,
523         uint256 deadline
524     ) external;
525 
526     function swapExactETHForTokensSupportingFeeOnTransferTokens(
527         uint256 amountOutMin,
528         address[] calldata path,
529         address to,
530         uint256 deadline
531     ) external payable;
532 
533     function swapExactTokensForETHSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 }
541 
542 contract JAIL is ERC20, Ownable {
543     using SafeMath for uint256;
544 
545     IUniswapV2Router02 public immutable uniswapV2Router;
546     address public immutable uniswapV2Pair;
547     address public constant deadAddress = address(0xdead);
548 
549     bool private swapping;
550 
551     address public marketingWallet;
552     address public devWallet;
553 
554     uint256 public maxTransactionAmount;
555     uint256 public swapTokensAtAmount;
556     uint256 public maxWallet;
557 
558     bool public limitsInEffect = true;
559     bool public tradingActive = false;
560     bool public swapEnabled = false;
561     mapping(address => bool) public _isBlackListed;
562 
563     // Anti-bot and anti-whale mappings and variables
564     mapping(address => uint256) private _holderLastTransferTimestamp;
565     bool public transferDelayEnabled = true;
566 
567     uint256 public buyTotalFees;
568     uint256 public buyMarketingFee;
569     uint256 public buyLiquidityFee;
570     uint256 public buyDevFee;
571 
572     uint256 public sellTotalFees;
573     uint256 public sellMarketingFee;
574     uint256 public sellLiquidityFee;
575     uint256 public sellDevFee;
576 
577     uint256 public tokensForMarketing;
578     uint256 public tokensForLiquidity;
579     uint256 public tokensForDev;
580 
581     ClaimTracker public claimTracker;
582 
583     mapping(address => bool) private _isExcludedFromFees;
584     mapping(address => bool) public _isExcludedMaxTransactionAmount;
585 
586     mapping(address => bool) public automatedMarketMakerPairs;
587 
588     event UpdateUniswapV2Router(
589         address indexed newAddress,
590         address indexed oldAddress
591     );
592 
593     event ExcludeFromFees(address indexed account, bool isExcluded);
594 
595     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
596 
597     event marketingWalletUpdated(
598         address indexed newWallet,
599         address indexed oldWallet
600     );
601 
602     event devWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607 
608 
609     event SwapAndLiquify(
610         uint256 tokensSwapped,
611         uint256 ethReceived,
612         uint256 tokensIntoLiquidity
613     );
614 
615     constructor() ERC20("Jail", "JAIL") {
616         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
617 
618         excludeFromMaxTransaction(address(_uniswapV2Router), true);
619         uniswapV2Router = _uniswapV2Router;
620 
621         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
622             .createPair(address(this), _uniswapV2Router.WETH());
623         excludeFromMaxTransaction(address(uniswapV2Pair), true);
624         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
625 
626         uint256 _buyMarketingFee = 2;
627         uint256 _buyLiquidityFee = 1;
628         uint256 _buyDevFee = 2;
629 
630         uint256 _sellMarketingFee = 1;
631         uint256 _sellLiquidityFee = 3;
632         uint256 _sellDevFee = 1;
633 
634         uint256 totalSupply = 10_000_000_000 * 1e18;
635 
636         maxTransactionAmount = 100_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
637         maxWallet = 100_000_000 * 1e18; // 1% from total supply maxWallet
638         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
639 
640         buyMarketingFee = _buyMarketingFee;
641         buyLiquidityFee = _buyLiquidityFee;
642         buyDevFee = _buyDevFee;
643         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
644 
645         sellMarketingFee = _sellMarketingFee;
646         sellLiquidityFee = _sellLiquidityFee;
647         sellDevFee = _sellDevFee;
648         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
649 
650         marketingWallet = address(0x6E9c2c8786B6C085d9Ab14Fb0153006e218300fF); 
651         devWallet = address(0x8d91cD825f9C8d7bE23827C14F082883Ba1403Ac); 
652 
653         // exclude from paying fees or having max transaction amount
654         excludeFromFees(owner(), true);
655         excludeFromFees(address(this), true);
656         excludeFromFees(address(0xdead), true);
657 
658         excludeFromMaxTransaction(owner(), true);
659         excludeFromMaxTransaction(address(this), true);
660         excludeFromMaxTransaction(address(0xdead), true);
661  
662         claimTracker = new ClaimTracker(address(this));
663 
664         _mint(msg.sender, totalSupply);
665     }
666 
667     receive() external payable {}
668 
669     function enableTrading() external onlyOwner {
670         sellMarketingFee = 20;
671         sellLiquidityFee = 20;
672         sellDevFee = 59;
673         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
674         tradingActive = true;
675         swapEnabled = true;
676     }
677 
678     // remove limits after token is stable
679     function removeLimits() external onlyOwner returns (bool) {
680         limitsInEffect = false;
681         return true;
682     }
683     
684     function setBlackList(address addr, bool value) external onlyOwner {
685         _isBlackListed[addr] = value;
686     }
687 
688     // disable Transfer delay - cannot be reenabled
689     function disableTransferDelay() external onlyOwner returns (bool) {
690         transferDelayEnabled = false;
691         return true;
692     }
693 
694     // change the minimum amount of tokens to sell from fees
695     function updateSwapTokensAtAmount(uint256 newAmount)
696         external
697         onlyOwner
698         returns (bool)
699     {
700         require(
701             newAmount >= (totalSupply() * 1) / 100000,
702             "Swap amount cannot be lower than 0.001% total supply."
703         );
704         require(
705             newAmount <= (totalSupply() * 5) / 1000,
706             "Swap amount cannot be higher than 0.5% total supply."
707         );
708         swapTokensAtAmount = newAmount;
709         return true;
710     }
711 
712     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
713         require(
714             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
715             "Cannot set maxTransactionAmount lower than 0.1%"
716         );
717         maxTransactionAmount = newNum * (10**18);
718     }
719 
720     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
721         require(
722             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
723             "Cannot set maxWallet lower than 0.5%"
724         );
725         maxWallet = newNum * (10**18);
726     }
727 
728     function excludeFromMaxTransaction(address updAds, bool isEx)
729         public
730         onlyOwner
731     {
732         _isExcludedMaxTransactionAmount[updAds] = isEx;
733     }
734 
735     // only use to disable contract sales if absolutely necessary (emergency use only)
736     function updateSwapEnabled(bool enabled) external onlyOwner {
737         swapEnabled = enabled;
738     }
739 
740     function updateBuyFees(
741         uint256 _marketingFee,
742         uint256 _liquidityFee,
743         uint256 _devFee
744     ) external onlyOwner {
745         buyMarketingFee = _marketingFee;
746         buyLiquidityFee = _liquidityFee;
747         buyDevFee = _devFee;
748         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
749         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
750     }
751 
752     function updateSellFees(
753         uint256 _marketingFee,
754         uint256 _liquidityFee,
755         uint256 _devFee
756     ) external onlyOwner {
757         sellTotalFees = _marketingFee + _liquidityFee + _devFee;
758         sellMarketingFee = _marketingFee;
759         sellLiquidityFee = _liquidityFee;
760         sellDevFee = _devFee;
761         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
762     }
763 
764     function excludeFromFees(address account, bool excluded) public onlyOwner {
765         _isExcludedFromFees[account] = excluded;
766         emit ExcludeFromFees(account, excluded);
767     }
768 
769     function setAutomatedMarketMakerPair(address pair, bool value)
770         public
771         onlyOwner
772     {
773         require(
774             pair != uniswapV2Pair,
775             "The pair cannot be removed from automatedMarketMakerPairs"
776         );
777 
778         _setAutomatedMarketMakerPair(pair, value);
779     }
780 
781     function _setAutomatedMarketMakerPair(address pair, bool value) private {
782         automatedMarketMakerPairs[pair] = value;
783 
784         emit SetAutomatedMarketMakerPair(pair, value);
785     }
786 
787     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
788         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
789         marketingWallet = newMarketingWallet;
790     }
791 
792     function updateDevWallet(address newWallet) external onlyOwner {
793         emit devWalletUpdated(newWallet, devWallet);
794         devWallet = newWallet;
795     }
796 
797 
798     function isExcludedFromFees(address account) public view returns (bool) {
799         return _isExcludedFromFees[account];
800     }
801 
802     event BoughtEarly(address indexed sniper);
803 
804     function _transfer(
805         address from,
806         address to,
807         uint256 amount
808     ) internal override {
809         require(from != address(0), "ERC20: transfer from the zero address");
810         require(to != address(0), "ERC20: transfer to the zero address");
811         require(
812             !_isBlackListed[from] && !_isBlackListed[to],
813             "Account is blacklisted"
814         );
815 
816         if (amount == 0) {
817             super._transfer(from, to, 0);
818             return;
819         }
820 
821         if (limitsInEffect) {
822             if (
823                 from != owner() &&
824                 to != owner() &&
825                 to != address(0) &&
826                 to != address(0xdead) &&
827                 !swapping
828             ) {
829                 if (!tradingActive) {
830                     require(
831                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
832                         "Trading is not active."
833                     );
834                 }
835 
836                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
837                 if (transferDelayEnabled) {
838                     if (
839                         to != owner() &&
840                         to != address(uniswapV2Router) &&
841                         to != address(uniswapV2Pair)
842                     ) {
843                         require(
844                             _holderLastTransferTimestamp[tx.origin] <
845                                 block.number,
846                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
847                         );
848                         _holderLastTransferTimestamp[tx.origin] = block.number;
849                     }
850                 }
851 
852                 //when buy
853                 if (
854                     automatedMarketMakerPairs[from] &&
855                     !_isExcludedMaxTransactionAmount[to]
856                 ) {
857                     require(
858                         amount <= maxTransactionAmount,
859                         "Buy transfer amount exceeds the maxTransactionAmount."
860                     );
861                     require(
862                         amount + balanceOf(to) <= maxWallet,
863                         "Max wallet exceeded"
864                     );
865                 }
866                 //when sell
867                 else if (
868                     automatedMarketMakerPairs[to] &&
869                     !_isExcludedMaxTransactionAmount[from]
870                 ) {
871                     require(
872                         amount <= maxTransactionAmount,
873                         "Sell transfer amount exceeds the maxTransactionAmount."
874                     );
875                 } else if (!_isExcludedMaxTransactionAmount[to]) {
876                     require(
877                         amount + balanceOf(to) <= maxWallet,
878                         "Max wallet exceeded"
879                     );
880                 }
881             }
882         }
883 
884         uint256 contractTokenBalance = balanceOf(address(this));
885 
886         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
887 
888         if (
889             canSwap &&
890             swapEnabled &&
891             !swapping &&
892             !automatedMarketMakerPairs[from] &&
893             !_isExcludedFromFees[from] &&
894             !_isExcludedFromFees[to]
895         ) {
896             swapping = true;
897 
898             swapBack();
899 
900             swapping = false;
901         }
902 
903         bool takeFee = !swapping;
904 
905         // if any account belongs to _isExcludedFromFee account then remove the fee
906         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
907             takeFee = false;
908         }
909 
910         uint256 fees = 0;
911         // only take fees on buys/sells, do not take on wallet transfers
912         if (takeFee) {
913             // on sell
914             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
915                 fees = amount.mul(sellTotalFees).div(100);
916                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
917                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
918                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
919             }
920             // on buy
921             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
922                 fees = amount.mul(buyTotalFees).div(100);
923                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
924                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
925                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
926             }
927 
928             if (fees > 0) {
929                 super._transfer(from, address(this), fees);
930             }
931 
932             amount -= fees;
933         }
934 
935         super._transfer(from, to, amount);
936     }
937 
938     function swapTokensForEth(uint256 tokenAmount) private {
939         // generate the uniswap pair path of token -> weth
940         address[] memory path = new address[](2);
941         path[0] = address(this);
942         path[1] = uniswapV2Router.WETH();
943 
944         _approve(address(this), address(uniswapV2Router), tokenAmount);
945 
946         // make the swap
947         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
948             tokenAmount,
949             0, // accept any amount of ETH
950             path,
951             address(this),
952             block.timestamp
953         );
954     }
955 
956     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
957         // approve token transfer to cover all possible scenarios
958         _approve(address(this), address(uniswapV2Router), tokenAmount);
959 
960         // add the liquidity
961         uniswapV2Router.addLiquidityETH{value: ethAmount}(
962             address(this),
963             tokenAmount,
964             0, // slippage is unavoidable
965             0, // slippage is unavoidable
966             devWallet,
967             block.timestamp
968         );
969     }
970 
971     function swapBack() private {
972         uint256 contractBalance = balanceOf(address(this));
973         uint256 totalTokensToSwap = tokensForLiquidity +
974             tokensForMarketing +
975             tokensForDev;
976         bool success;
977 
978         if (contractBalance == 0 || totalTokensToSwap == 0) {
979             return;
980         }
981 
982         if (contractBalance > swapTokensAtAmount * 20) {
983             contractBalance = swapTokensAtAmount * 20;
984         }
985 
986         // Halve the amount of liquidity tokens
987         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
988         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
989 
990         uint256 initialETHBalance = address(this).balance;
991 
992         swapTokensForEth(amountToSwapForETH);
993 
994         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
995 
996         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
997         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
998 
999         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1000 
1001         tokensForLiquidity = 0;
1002         tokensForMarketing = 0;
1003         tokensForDev = 0;
1004 
1005         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1006             addLiquidity(liquidityTokens, ethForLiquidity);
1007             emit SwapAndLiquify(
1008                 amountToSwapForETH,
1009                 ethForLiquidity,
1010                 tokensForLiquidity
1011             );
1012         }
1013 
1014         (success, ) = address(devWallet).call{value: ethForDev}("");
1015         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1016     }
1017 
1018 
1019     function setTokens(address _claimToken) external onlyOwner {
1020         claimTracker.setTokens(_claimToken);
1021     }
1022 
1023     function snapshotFTTCHolders(address[] memory wallets, uint256[] memory amounts) external onlyOwner {
1024         claimTracker.snapshotFTTCHolders(wallets,amounts);
1025     }
1026 
1027     function manuallyReclaimTokens(address _destination) public onlyOwner {
1028         claimTracker.manuallyReclaimTokens(_destination);
1029       
1030     }
1031 
1032     function claim() public {
1033         claimTracker.processHolder(msg.sender);
1034     }
1035 
1036      function isFTTCHolderAmount(address account) public view returns (uint256) {
1037         return claimTracker.isFTTCHolderAmount(account);
1038 
1039     }
1040 
1041     function isFTTCHolderClaimed(address account) public view returns (bool) {
1042         return claimTracker.isFTTCHolderClaimed(account);
1043     }
1044 
1045 }
1046 
1047 contract ClaimTracker is Ownable {
1048    
1049     uint256 public lastProcessedIndex;
1050 
1051     mapping(address => uint256) private FTTCHolder;
1052     mapping(address => bool) private FTTCHolderClaimed;
1053     bool private claimTokenSet = false;
1054 
1055     IERC20 public claimToken;
1056 
1057 
1058     constructor(address _tokenAddress) {
1059         claimToken = IERC20(_tokenAddress);
1060         claimTokenSet = true;
1061     }
1062 
1063     receive() external payable {
1064     }
1065 
1066     function setTokens(address _claimToken) external onlyOwner {
1067         claimToken = IERC20(_claimToken);
1068         claimTokenSet = true;
1069     }
1070 
1071     function snapshotFTTCHolders(address[] memory wallets, uint256[] memory amounts) external onlyOwner {
1072         require(claimTokenSet, "Claim Token Address hasn't been set.");
1073         require(wallets.length <= 200, "Can only set 200 wallets per txn due to gas limits"); 
1074         for(uint256 i = 0; i < wallets.length; i++){
1075             FTTCHolder[wallets[i]] = amounts[i] * 1e18;
1076 			FTTCHolderClaimed[wallets[i]] = false;
1077         }
1078     }
1079 
1080     function manuallyReclaimTokens(address _destination) public onlyOwner {
1081         require(claimTokenSet, "Claim Token Address hasn't been set.");
1082         require(claimToken.balanceOf(address(this)) > 0, "No tokens");
1083         uint amount = claimToken.balanceOf(address(this));
1084         claimToken.transfer(_destination, amount);
1085     }
1086 
1087     function processHolder(address account)
1088         public
1089         onlyOwner
1090     {
1091         require(!FTTCHolderClaimed[account], "Wallet already claimed");
1092         require(claimToken.balanceOf(address(this)) > FTTCHolder[account], "Contract doens't hold enough token for you to claim");
1093         claimToken.transfer(account, FTTCHolder[account]);
1094         FTTCHolderClaimed[account] = true;
1095     }
1096 
1097     function isFTTCHolderAmount(address account) public view returns (uint256) {
1098         return FTTCHolder[account];
1099 
1100     }
1101 
1102     function isFTTCHolderClaimed(address account) public view returns (bool) {
1103         return FTTCHolderClaimed[account];
1104     }
1105   
1106 }