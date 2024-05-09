1 /*
2 zkBitcoin, the Future of Digital Currency with unparalleled protection through Zero Knowledge technology.
3 https://zkbitcoin.co/
4 https://t.me/zkbitcoinofficial
5 https://twitter.com/zkBitcoinzkB
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
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
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         _transferOwnership(newOwner);
52     }
53 
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 
63 interface IERC20 {
64 
65     function totalSupply() external view returns (uint256);
66 
67     function balanceOf(address account) external view returns (uint256);
68 
69 
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77 
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 interface IERC20Metadata is IERC20 {
92 
93     function name() external view returns (string memory);
94 
95     function symbol() external view returns (string memory);
96 
97     function decimals() external view returns (uint8);
98 }
99 
100 
101 contract ERC20 is Context, IERC20, IERC20Metadata {
102     mapping(address => uint256) private _balances;
103 
104     mapping(address => mapping(address => uint256)) private _allowances;
105 
106     uint256 private _totalSupply;
107 
108     string private _name;
109     string private _symbol;
110 
111 
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
123 
124     function symbol() public view virtual override returns (string memory) {
125         return _symbol;
126     }
127 
128 
129     function decimals() public view virtual override returns (uint8) {
130         return 18;
131     }
132 
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
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         _beforeTokenTransfer(sender, recipient, amount);
197 
198         uint256 senderBalance = _balances[sender];
199         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
200         unchecked {
201             _balances[sender] = senderBalance - amount;
202         }
203         _balances[recipient] += amount;
204 
205         emit Transfer(sender, recipient, amount);
206 
207         _afterTokenTransfer(sender, recipient, amount);
208     }
209 
210     function _mint(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212 
213         _beforeTokenTransfer(address(0), account, amount);
214 
215         _totalSupply += amount;
216         _balances[account] += amount;
217         emit Transfer(address(0), account, amount);
218 
219         _afterTokenTransfer(address(0), account, amount);
220     }
221 
222     function _burn(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: burn from the zero address");
224 
225         _beforeTokenTransfer(account, address(0), amount);
226 
227         uint256 accountBalance = _balances[account];
228         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
229         unchecked {
230             _balances[account] = accountBalance - amount;
231         }
232         _totalSupply -= amount;
233 
234         emit Transfer(account, address(0), amount);
235 
236         _afterTokenTransfer(account, address(0), amount);
237     }
238 
239     function _approve(
240         address owner,
241         address spender,
242         uint256 amount
243     ) internal virtual {
244         require(owner != address(0), "ERC20: approve from the zero address");
245         require(spender != address(0), "ERC20: approve to the zero address");
246 
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _beforeTokenTransfer(
252         address from,
253         address to,
254         uint256 amount
255     ) internal virtual {}
256 
257     function _afterTokenTransfer(
258         address from,
259         address to,
260         uint256 amount
261     ) internal virtual {}
262 }
263 
264 
265 library SafeMath {
266 
267     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             uint256 c = a + b;
270             if (c < a) return (false, 0);
271             return (true, c);
272         }
273     }
274 
275     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (b > a) return (false, 0);
278             return (true, a - b);
279         }
280     }
281 
282 
283     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             if (a == 0) return (true, 0);
286             uint256 c = a * b;
287             if (c / a != b) return (false, 0);
288             return (true, c);
289         }
290     }
291 
292     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         unchecked {
294             if (b == 0) return (false, 0);
295             return (true, a / b);
296         }
297     }
298 
299     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             if (b == 0) return (false, 0);
302             return (true, a % b);
303         }
304     }
305 
306 
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a + b;
309     }
310 
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a - b;
313     }
314 
315     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a * b;
317     }
318 
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a / b;
321     }
322 
323     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a % b;
325     }
326 
327     function sub(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b <= a, errorMessage);
334             return a - b;
335         }
336     }
337 
338     function div(
339         uint256 a,
340         uint256 b,
341         string memory errorMessage
342     ) internal pure returns (uint256) {
343         unchecked {
344             require(b > 0, errorMessage);
345             return a / b;
346         }
347     }
348 
349 
350     function mod(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b > 0, errorMessage);
357             return a % b;
358         }
359     }
360 }
361 
362 
363 interface IUniswapV2Factory {
364     event PairCreated(
365         address indexed token0,
366         address indexed token1,
367         address pair,
368         uint256
369     );
370 
371     function feeTo() external view returns (address);
372 
373     function feeToSetter() external view returns (address);
374 
375     function getPair(address tokenA, address tokenB)
376         external
377         view
378         returns (address pair);
379 
380     function allPairs(uint256) external view returns (address pair);
381 
382     function allPairsLength() external view returns (uint256);
383 
384     function createPair(address tokenA, address tokenB)
385         external
386         returns (address pair);
387 
388     function setFeeTo(address) external;
389 
390     function setFeeToSetter(address) external;
391 }
392 
393 
394 interface IUniswapV2Pair {
395     event Approval(
396         address indexed owner,
397         address indexed spender,
398         uint256 value
399     );
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     function name() external pure returns (string memory);
403 
404     function symbol() external pure returns (string memory);
405 
406     function decimals() external pure returns (uint8);
407 
408     function totalSupply() external view returns (uint256);
409 
410     function balanceOf(address owner) external view returns (uint256);
411 
412     function allowance(address owner, address spender)
413         external
414         view
415         returns (uint256);
416 
417     function approve(address spender, uint256 value) external returns (bool);
418 
419     function transfer(address to, uint256 value) external returns (bool);
420 
421     function transferFrom(
422         address from,
423         address to,
424         uint256 value
425     ) external returns (bool);
426 
427     function DOMAIN_SEPARATOR() external view returns (bytes32);
428 
429     function PERMIT_TYPEHASH() external pure returns (bytes32);
430 
431     function nonces(address owner) external view returns (uint256);
432 
433     function permit(
434         address owner,
435         address spender,
436         uint256 value,
437         uint256 deadline,
438         uint8 v,
439         bytes32 r,
440         bytes32 s
441     ) external;
442 
443     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
444     event Burn(
445         address indexed sender,
446         uint256 amount0,
447         uint256 amount1,
448         address indexed to
449     );
450     event Swap(
451         address indexed sender,
452         uint256 amount0In,
453         uint256 amount1In,
454         uint256 amount0Out,
455         uint256 amount1Out,
456         address indexed to
457     );
458     event Sync(uint112 reserve0, uint112 reserve1);
459 
460     function MINIMUM_LIQUIDITY() external pure returns (uint256);
461 
462     function factory() external view returns (address);
463 
464     function token0() external view returns (address);
465 
466     function token1() external view returns (address);
467 
468     function getReserves()
469         external
470         view
471         returns (
472             uint112 reserve0,
473             uint112 reserve1,
474             uint32 blockTimestampLast
475         );
476 
477     function price0CumulativeLast() external view returns (uint256);
478 
479     function price1CumulativeLast() external view returns (uint256);
480 
481     function kLast() external view returns (uint256);
482 
483     function mint(address to) external returns (uint256 liquidity);
484 
485     function burn(address to)
486         external
487         returns (uint256 amount0, uint256 amount1);
488 
489     function swap(
490         uint256 amount0Out,
491         uint256 amount1Out,
492         address to,
493         bytes calldata data
494     ) external;
495 
496     function skim(address to) external;
497 
498     function sync() external;
499 
500     function initialize(address, address) external;
501 }
502 
503 
504 interface IUniswapV2Router02 {
505     function factory() external pure returns (address);
506 
507     function WETH() external pure returns (address);
508 
509     function addLiquidity(
510         address tokenA,
511         address tokenB,
512         uint256 amountADesired,
513         uint256 amountBDesired,
514         uint256 amountAMin,
515         uint256 amountBMin,
516         address to,
517         uint256 deadline
518     )
519         external
520         returns (
521             uint256 amountA,
522             uint256 amountB,
523             uint256 liquidity
524         );
525 
526     function addLiquidityETH(
527         address token,
528         uint256 amountTokenDesired,
529         uint256 amountTokenMin,
530         uint256 amountETHMin,
531         address to,
532         uint256 deadline
533     )
534         external
535         payable
536         returns (
537             uint256 amountToken,
538             uint256 amountETH,
539             uint256 liquidity
540         );
541 
542     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
543         uint256 amountIn,
544         uint256 amountOutMin,
545         address[] calldata path,
546         address to,
547         uint256 deadline
548     ) external;
549 
550     function swapExactETHForTokensSupportingFeeOnTransferTokens(
551         uint256 amountOutMin,
552         address[] calldata path,
553         address to,
554         uint256 deadline
555     ) external payable;
556 
557     function swapExactTokensForETHSupportingFeeOnTransferTokens(
558         uint256 amountIn,
559         uint256 amountOutMin,
560         address[] calldata path,
561         address to,
562         uint256 deadline
563     ) external;
564 }
565 
566 
567 
568 contract zkBitcoin is ERC20, Ownable { 
569     using SafeMath for uint256;
570 
571     IUniswapV2Router02 public immutable uniswapV2Router;
572     address public immutable uniswapV2Pair;
573     address public constant deadAddress = address(0xdead);
574 
575     bool private swapping;
576 
577     address private marketingWallet;
578     address private developmentWallet;
579 
580     uint256 public percentForLPBurn = 0; 
581     bool public lpBurnEnabled = false;
582     uint256 public lpBurnFrequency = 3600 seconds;
583     uint256 public lastLpBurnTime;
584 
585     uint256 public maxTransactionAmount;
586     uint256 public swapTokensAtAmount;
587     uint256 public maxWallet;
588 
589     bool public limitsInEffect = true;
590     bool public tradingActive = false;
591     bool public swapEnabled = true;
592 
593     uint256 public manualBurnFrequency = 30 minutes;
594     uint256 public lastManualLpBurnTime;
595 
596 
597 
598     mapping(address => uint256) private _holderLastTransferTimestamp; 
599     bool public transferDelayEnabled = true;
600 
601     uint256 public buyTotalFees;
602     uint256 public buyMarketingFee;
603     uint256 public buyLiquidityFee;
604     uint256 public buyDevelopmentFee;
605 
606     uint256 public sellTotalFees;
607     uint256 public sellMarketingFee;
608     uint256 public sellLiquidityFee;
609     uint256 public sellDevelopmentFee;
610 
611     uint256 public tokensForMarketing;
612     uint256 public tokensForLiquidity;
613     uint256 public tokensForDev;
614 
615     mapping(address => bool) private _isExcludedFromFees;
616     mapping(address => bool) public _isExcludedMaxTransactionAmount;
617 
618     mapping(address => bool) public automatedMarketMakerPairs;
619 
620     event UpdateUniswapV2Router(
621         address indexed newAddress,
622         address indexed oldAddress
623     );
624 
625     event ExcludeFromFees(address indexed account, bool isExcluded);
626 
627     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
628 
629     event marketingWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633 
634     event developmentWalletUpdated(
635         address indexed newWallet,
636         address indexed oldWallet
637     );
638 
639     event SwapAndLiquify(
640         uint256 tokensSwapped,
641         uint256 ethReceived,
642         uint256 tokensIntoLiquidity
643     );
644 
645     event AutoNukeLP();
646 
647     event ManualNukeLP();
648 
649     constructor() ERC20("zkBitcoin", "zkBTC") {
650         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
651             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
652         );
653 
654         excludeFromMaxTransaction(address(_uniswapV2Router), true);
655         uniswapV2Router = _uniswapV2Router;
656 
657         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
658             .createPair(address(this), _uniswapV2Router.WETH());
659         excludeFromMaxTransaction(address(uniswapV2Pair), true);
660         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
661 
662         uint256 _buyMarketingFee = 20;
663         uint256 _buyLiquidityFee = 0;
664         uint256 _buyDevelopmentFee = 5; 
665 
666         uint256 _sellMarketingFee = 30;
667         uint256 _sellLiquidityFee = 0;
668         uint256 _sellDevelopmentFee = 15; 
669 
670         uint256 totalSupply = 21_000_000 * 1e18; 
671 
672         maxTransactionAmount = 420_000 * 1e18;
673         maxWallet = 420_000 * 1e18;
674         swapTokensAtAmount = (totalSupply * 10) / 10000;
675 
676         buyMarketingFee = _buyMarketingFee;
677         buyLiquidityFee = _buyLiquidityFee;
678         buyDevelopmentFee = _buyDevelopmentFee;
679         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
680 
681         sellMarketingFee = _sellMarketingFee;
682         sellLiquidityFee = _sellLiquidityFee;
683         sellDevelopmentFee = _sellDevelopmentFee;
684         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
685 
686         marketingWallet = address(0xa0Dba9887dB6AaFD538Ae1C755F40D3b5ADeD8d2); 
687         developmentWallet = address(0xDA53e59818Bd647b6F4c078a40b9483CBBfA593b);
688 
689         excludeFromFees(owner(), true);
690         excludeFromFees(address(this), true);
691         excludeFromFees(address(0xdead), true);
692 
693         excludeFromMaxTransaction(owner(), true);
694         excludeFromMaxTransaction(address(this), true);
695         excludeFromMaxTransaction(address(0xdead), true);
696 
697         _mint(msg.sender, totalSupply);
698     }
699 
700     receive() external payable {}
701 
702     function enableTrade() external onlyOwner {
703         tradingActive = true;
704         swapEnabled = true;
705         lastLpBurnTime = block.timestamp;
706     }
707 
708     function removeLimits() external onlyOwner returns (bool) {
709         limitsInEffect = false;
710         return true;
711     }
712 
713     function disableTransferDelay() external onlyOwner returns (bool) {
714         transferDelayEnabled = false;
715         return true;
716     }
717 
718     function updateSwapTokensAtAmount(uint256 newAmount)
719         external
720         onlyOwner
721         returns (bool)
722     {
723         require(
724             newAmount >= (totalSupply() * 1) / 100000,
725             "Swap amount cannot be lower than 0.001% total supply."
726         );
727         require(
728             newAmount <= (totalSupply() * 5) / 1000,
729             "Swap amount cannot be higher than 0.5% total supply."
730         );
731         swapTokensAtAmount = newAmount;
732         return true;
733     }
734 
735     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
736         require(
737             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
738             "Cannot set maxTransactionAmount lower than 0.1%"
739         );
740         maxTransactionAmount = newNum * (10**18);
741     }
742 
743     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
744         require(
745             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
746             "Cannot set maxWallet lower than 0.5%"
747         );
748         maxWallet = newNum * (10**18);
749     }
750 
751     function excludeFromMaxTransaction(address updAds, bool isEx)
752         public
753         onlyOwner
754     {
755         _isExcludedMaxTransactionAmount[updAds] = isEx;
756     }
757 
758     function updateSwapEnabled(bool enabled) external onlyOwner {
759         swapEnabled = enabled;
760     }
761 
762     function updateBuyFees(
763         uint256 _marketingFee,
764         uint256 _liquidityFee,
765         uint256 _developmentFee
766     ) external onlyOwner {
767         buyMarketingFee = _marketingFee;
768         buyLiquidityFee = _liquidityFee;
769         buyDevelopmentFee = _developmentFee;
770         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
771     }
772 
773     function updateSellFees(
774         uint256 _marketingFee,
775         uint256 _liquidityFee,
776         uint256 _developmentFee
777     ) external onlyOwner {
778         sellMarketingFee = _marketingFee;
779         sellLiquidityFee = _liquidityFee;
780         sellDevelopmentFee = _developmentFee;
781         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
782     }
783 
784     function excludeFromFees(address account, bool excluded) public onlyOwner {
785         _isExcludedFromFees[account] = excluded;
786         emit ExcludeFromFees(account, excluded);
787     }
788 
789     function setAutomatedMarketMakerPair(address pair, bool value)
790         public
791         onlyOwner
792     {
793         require(
794             pair != uniswapV2Pair,
795             "The pair cannot be removed from automatedMarketMakerPairs"
796         );
797 
798         _setAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function _setAutomatedMarketMakerPair(address pair, bool value) private {
802         automatedMarketMakerPairs[pair] = value;
803 
804         emit SetAutomatedMarketMakerPair(pair, value);
805     }
806 
807     function updateMarketingWalletInfo(address newMarketingWallet)
808         external
809         onlyOwner
810     {
811         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
812         marketingWallet = newMarketingWallet;
813     }
814 
815     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
816         emit developmentWalletUpdated(newWallet, developmentWallet);
817         developmentWallet = newWallet;
818     }
819 
820     function isExcludedFromFees(address account) public view returns (bool) {
821         return _isExcludedFromFees[account];
822     }
823 
824     event BoughtEarly(address indexed sniper);
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal override {
831         require(from != address(0), "ERC20: transfer from the zero address");
832         require(to != address(0), "ERC20: transfer to the zero address");
833 
834         if (amount == 0) {
835             super._transfer(from, to, 0);
836             return;
837         }
838 
839         if (limitsInEffect) {
840             if (
841                 from != owner() &&
842                 to != owner() &&
843                 to != address(0) &&
844                 to != address(0xdead) &&
845                 !swapping
846             ) {
847                 if (!tradingActive) {
848                     require(
849                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
850                         "Trading is not active."
851                     );
852                 }
853 
854                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
855                 if (transferDelayEnabled) {
856                     if (
857                         to != owner() &&
858                         to != address(uniswapV2Router) &&
859                         to != address(uniswapV2Pair)
860                     ) {
861                         require(
862                             _holderLastTransferTimestamp[tx.origin] <
863                                 block.number,
864                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
865                         );
866                         _holderLastTransferTimestamp[tx.origin] = block.number;
867                     }
868                 }
869 
870                 //when buy
871                 if (
872                     automatedMarketMakerPairs[from] &&
873                     !_isExcludedMaxTransactionAmount[to]
874                 ) {
875                     require(
876                         amount <= maxTransactionAmount,
877                         "Buy transfer amount exceeds the maxTransactionAmount."
878                     );
879                     require(
880                         amount + balanceOf(to) <= maxWallet,
881                         "Max wallet exceeded"
882                     );
883                 }
884                 //when sell
885                 else if (
886                     automatedMarketMakerPairs[to] &&
887                     !_isExcludedMaxTransactionAmount[from]
888                 ) {
889                     require(
890                         amount <= maxTransactionAmount,
891                         "Sell transfer amount exceeds the maxTransactionAmount."
892                     );
893                 } else if (!_isExcludedMaxTransactionAmount[to]) {
894                     require(
895                         amount + balanceOf(to) <= maxWallet,
896                         "Max wallet exceeded"
897                     );
898                 }
899             }
900         }
901 
902         uint256 contractTokenBalance = balanceOf(address(this));
903 
904         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
905 
906         if (
907             canSwap &&
908             swapEnabled &&
909             !swapping &&
910             !automatedMarketMakerPairs[from] &&
911             !_isExcludedFromFees[from] &&
912             !_isExcludedFromFees[to]
913         ) {
914             swapping = true;
915 
916             swapBack();
917 
918             swapping = false;
919         }
920 
921         if (
922             !swapping &&
923             automatedMarketMakerPairs[to] &&
924             lpBurnEnabled &&
925             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
926             !_isExcludedFromFees[from]
927         ) {
928             autoBurnLiquidityPairTokens();
929         }
930 
931         bool takeFee = !swapping;
932 
933         // if any account belongs to _isExcludedFromFee account then remove the fee
934         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
935             takeFee = false;
936         }
937 
938         uint256 fees = 0;
939         // only take fees on buys/sells, do not take on wallet transfers
940         if (takeFee) {
941             // on sell
942             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
943                 fees = amount.mul(sellTotalFees).div(100);
944                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
945                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
946                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
947             }
948             // on buy
949             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
950                 fees = amount.mul(buyTotalFees).div(100);
951                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
952                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
953                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
954             }
955 
956             if (fees > 0) {
957                 super._transfer(from, address(this), fees);
958             }
959 
960             amount -= fees;
961         }
962 
963         super._transfer(from, to, amount);
964     }
965 
966     function swapTokensForEth(uint256 tokenAmount) private {
967         // generate the uniswap pair path of token -> weth
968         address[] memory path = new address[](2);
969         path[0] = address(this);
970         path[1] = uniswapV2Router.WETH();
971 
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // make the swap
975         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
976             tokenAmount,
977             0, // accept any amount of ETH
978             path,
979             address(this),
980             block.timestamp
981         );
982     }
983 
984     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
985         // approve token transfer to cover all possible scenarios
986         _approve(address(this), address(uniswapV2Router), tokenAmount);
987 
988         // add the liquidity
989         uniswapV2Router.addLiquidityETH{value: ethAmount}(
990             address(this),
991             tokenAmount,
992             0, // slippage is unavoidable
993             0, // slippage is unavoidable
994             deadAddress,
995             block.timestamp
996         );
997     }
998 
999     function swapBack() private {
1000         uint256 contractBalance = balanceOf(address(this));
1001         uint256 totalTokensToSwap = tokensForLiquidity +
1002             tokensForMarketing +
1003             tokensForDev;
1004         bool success;
1005 
1006         if (contractBalance == 0 || totalTokensToSwap == 0) {
1007             return;
1008         }
1009 
1010         if (contractBalance > swapTokensAtAmount * 20) {
1011             contractBalance = swapTokensAtAmount * 20;
1012         }
1013 
1014         // Halve the amount of liquidity tokens
1015         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1016             totalTokensToSwap /
1017             2;
1018         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1019 
1020         uint256 initialETHBalance = address(this).balance;
1021 
1022         swapTokensForEth(amountToSwapForETH);
1023 
1024         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1025 
1026         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1027             totalTokensToSwap
1028         );
1029         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1030 
1031         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1032 
1033         tokensForLiquidity = 0;
1034         tokensForMarketing = 0;
1035         tokensForDev = 0;
1036 
1037         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1038 
1039         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1040             addLiquidity(liquidityTokens, ethForLiquidity);
1041             emit SwapAndLiquify(
1042                 amountToSwapForETH,
1043                 ethForLiquidity,
1044                 tokensForLiquidity
1045             );
1046         }
1047 
1048         (success, ) = address(marketingWallet).call{
1049             value: address(this).balance
1050         }("");
1051     }
1052 
1053     function setAutoLPBurnSettings(
1054         uint256 _frequencyInSeconds,
1055         uint256 _percent,
1056         bool _Enabled
1057     ) external onlyOwner {
1058         require(
1059             _frequencyInSeconds >= 600,
1060             "cannot set buyback more often than every 10 minutes"
1061         );
1062         require(
1063             _percent <= 1000 && _percent >= 0,
1064             "Must set auto LP burn percent between 0% and 10%"
1065         );
1066         lpBurnFrequency = _frequencyInSeconds;
1067         percentForLPBurn = _percent;
1068         lpBurnEnabled = _Enabled;
1069     }
1070 
1071     function autoBurnLiquidityPairTokens() internal returns (bool) {
1072         lastLpBurnTime = block.timestamp;
1073 
1074         // get balance of liquidity pair
1075         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1076 
1077         // calculate amount to burn
1078         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1079             10000
1080         );
1081 
1082         // pull tokens from pancakePair liquidity and move to dead address permanently
1083         if (amountToBurn > 0) {
1084             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1085         }
1086 
1087         //sync price since this is not in a swap transaction!
1088         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1089         pair.sync();
1090         emit AutoNukeLP();
1091         return true;
1092     }
1093 
1094     function manualBurnLiquidityPairTokens(uint256 percent)
1095         external
1096         onlyOwner
1097         returns (bool)
1098     {
1099         require(
1100             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1101             "Must wait for cooldown to finish"
1102         );
1103         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1104         lastManualLpBurnTime = block.timestamp;
1105 
1106         // get balance of liquidity pair
1107         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1108 
1109         // calculate amount to burn
1110         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1111 
1112         // pull tokens from pancakePair liquidity and move to dead address permanently
1113         if (amountToBurn > 0) {
1114             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1115         }
1116 
1117         //sync price since this is not in a swap transaction!
1118         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1119         pair.sync();
1120         emit ManualNukeLP();
1121         return true;
1122     }
1123 }