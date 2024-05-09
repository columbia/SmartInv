1 /**
2 https://hubriscoin.io
3 https://twitter.com/hubriscoin
4 https://t.me/hubriscoin
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
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
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 
61 interface IERC20 {
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address account) external view returns (uint256);
66 
67 
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70 
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 interface IERC20Metadata is IERC20 {
90 
91     function name() external view returns (string memory);
92 
93     function symbol() external view returns (string memory);
94 
95     function decimals() external view returns (uint8);
96 }
97 
98 
99 contract ERC20 is Context, IERC20, IERC20Metadata {
100     mapping(address => uint256) private _balances;
101 
102     mapping(address => mapping(address => uint256)) private _allowances;
103 
104     uint256 private _totalSupply;
105 
106     string private _name;
107     string private _symbol;
108 
109 
110 
111     constructor(string memory name_, string memory symbol_) {
112         _name = name_;
113         _symbol = symbol_;
114     }
115 
116 
117     function name() public view virtual override returns (string memory) {
118         return _name;
119     }
120 
121 
122     function symbol() public view virtual override returns (string memory) {
123         return _symbol;
124     }
125 
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131 
132     function totalSupply() public view virtual override returns (uint256) {
133         return _totalSupply;
134     }
135 
136     function balanceOf(address account) public view virtual override returns (uint256) {
137         return _balances[account];
138     }
139 
140     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
141         _transfer(_msgSender(), recipient, amount);
142         return true;
143     }
144 
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
262 
263 library SafeMath {
264 
265     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             uint256 c = a + b;
268             if (c < a) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b > a) return (false, 0);
276             return (true, a - b);
277         }
278     }
279 
280 
281     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (a == 0) return (true, 0);
284             uint256 c = a * b;
285             if (c / a != b) return (false, 0);
286             return (true, c);
287         }
288     }
289 
290     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a / b);
294         }
295     }
296 
297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         unchecked {
299             if (b == 0) return (false, 0);
300             return (true, a % b);
301         }
302     }
303 
304 
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a + b;
307     }
308 
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a - b;
311     }
312 
313     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a * b;
315     }
316 
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a / b;
319     }
320 
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a % b;
323     }
324 
325     function sub(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b <= a, errorMessage);
332             return a - b;
333         }
334     }
335 
336     function div(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b > 0, errorMessage);
343             return a / b;
344         }
345     }
346 
347 
348     function mod(
349         uint256 a,
350         uint256 b,
351         string memory errorMessage
352     ) internal pure returns (uint256) {
353         unchecked {
354             require(b > 0, errorMessage);
355             return a % b;
356         }
357     }
358 }
359 
360 
361 interface IUniswapV2Factory {
362     event PairCreated(
363         address indexed token0,
364         address indexed token1,
365         address pair,
366         uint256
367     );
368 
369     function feeTo() external view returns (address);
370 
371     function feeToSetter() external view returns (address);
372 
373     function getPair(address tokenA, address tokenB)
374         external
375         view
376         returns (address pair);
377 
378     function allPairs(uint256) external view returns (address pair);
379 
380     function allPairsLength() external view returns (uint256);
381 
382     function createPair(address tokenA, address tokenB)
383         external
384         returns (address pair);
385 
386     function setFeeTo(address) external;
387 
388     function setFeeToSetter(address) external;
389 }
390 
391 
392 interface IUniswapV2Pair {
393     event Approval(
394         address indexed owner,
395         address indexed spender,
396         uint256 value
397     );
398     event Transfer(address indexed from, address indexed to, uint256 value);
399 
400     function name() external pure returns (string memory);
401 
402     function symbol() external pure returns (string memory);
403 
404     function decimals() external pure returns (uint8);
405 
406     function totalSupply() external view returns (uint256);
407 
408     function balanceOf(address owner) external view returns (uint256);
409 
410     function allowance(address owner, address spender)
411         external
412         view
413         returns (uint256);
414 
415     function approve(address spender, uint256 value) external returns (bool);
416 
417     function transfer(address to, uint256 value) external returns (bool);
418 
419     function transferFrom(
420         address from,
421         address to,
422         uint256 value
423     ) external returns (bool);
424 
425     function DOMAIN_SEPARATOR() external view returns (bytes32);
426 
427     function PERMIT_TYPEHASH() external pure returns (bytes32);
428 
429     function nonces(address owner) external view returns (uint256);
430 
431     function permit(
432         address owner,
433         address spender,
434         uint256 value,
435         uint256 deadline,
436         uint8 v,
437         bytes32 r,
438         bytes32 s
439     ) external;
440 
441     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
442     event Burn(
443         address indexed sender,
444         uint256 amount0,
445         uint256 amount1,
446         address indexed to
447     );
448     event Swap(
449         address indexed sender,
450         uint256 amount0In,
451         uint256 amount1In,
452         uint256 amount0Out,
453         uint256 amount1Out,
454         address indexed to
455     );
456     event Sync(uint112 reserve0, uint112 reserve1);
457 
458     function MINIMUM_LIQUIDITY() external pure returns (uint256);
459 
460     function factory() external view returns (address);
461 
462     function token0() external view returns (address);
463 
464     function token1() external view returns (address);
465 
466     function getReserves()
467         external
468         view
469         returns (
470             uint112 reserve0,
471             uint112 reserve1,
472             uint32 blockTimestampLast
473         );
474 
475     function price0CumulativeLast() external view returns (uint256);
476 
477     function price1CumulativeLast() external view returns (uint256);
478 
479     function kLast() external view returns (uint256);
480 
481     function mint(address to) external returns (uint256 liquidity);
482 
483     function burn(address to)
484         external
485         returns (uint256 amount0, uint256 amount1);
486 
487     function swap(
488         uint256 amount0Out,
489         uint256 amount1Out,
490         address to,
491         bytes calldata data
492     ) external;
493 
494     function skim(address to) external;
495 
496     function sync() external;
497 
498     function initialize(address, address) external;
499 }
500 
501 
502 interface IUniswapV2Router02 {
503     function factory() external pure returns (address);
504 
505     function WETH() external pure returns (address);
506 
507     function addLiquidity(
508         address tokenA,
509         address tokenB,
510         uint256 amountADesired,
511         uint256 amountBDesired,
512         uint256 amountAMin,
513         uint256 amountBMin,
514         address to,
515         uint256 deadline
516     )
517         external
518         returns (
519             uint256 amountA,
520             uint256 amountB,
521             uint256 liquidity
522         );
523 
524     function addLiquidityETH(
525         address token,
526         uint256 amountTokenDesired,
527         uint256 amountTokenMin,
528         uint256 amountETHMin,
529         address to,
530         uint256 deadline
531     )
532         external
533         payable
534         returns (
535             uint256 amountToken,
536             uint256 amountETH,
537             uint256 liquidity
538         );
539 
540     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
541         uint256 amountIn,
542         uint256 amountOutMin,
543         address[] calldata path,
544         address to,
545         uint256 deadline
546     ) external;
547 
548     function swapExactETHForTokensSupportingFeeOnTransferTokens(
549         uint256 amountOutMin,
550         address[] calldata path,
551         address to,
552         uint256 deadline
553     ) external payable;
554 
555     function swapExactTokensForETHSupportingFeeOnTransferTokens(
556         uint256 amountIn,
557         uint256 amountOutMin,
558         address[] calldata path,
559         address to,
560         uint256 deadline
561     ) external;
562 }
563 
564 
565 
566 contract HubrisCoin is ERC20, Ownable {
567     using SafeMath for uint256;
568 
569     IUniswapV2Router02 public immutable uniswapV2Router;
570     address public immutable uniswapV2Pair;
571     address public constant deadAddress = address(0xdead);
572 
573     bool private swapping;
574 
575     address private marketingWallet;
576     address private developmentWallet;
577 
578     uint256 public percentForLPBurn = 0; 
579     bool public lpBurnEnabled = false;
580     uint256 public lpBurnFrequency = 3600 seconds;
581     uint256 public lastLpBurnTime;
582 
583     uint256 public maxTransactionAmount;
584     uint256 public swapTokensAtAmount;
585     uint256 public maxWallet;
586 
587     bool public limitsInEffect = true;
588     bool public tradingActive = true;
589     bool public swapEnabled = true;
590 
591     uint256 public manualBurnFrequency = 30 minutes;
592     uint256 public lastManualLpBurnTime;
593 
594 
595 
596     mapping(address => uint256) private _holderLastTransferTimestamp; 
597     bool public transferDelayEnabled = true;
598 
599     uint256 public buyTotalFees;
600     uint256 public buyMarketingFee;
601     uint256 public buyLiquidityFee;
602     uint256 public buyDevelopmentFee;
603 
604     uint256 public sellTotalFees;
605     uint256 public sellMarketingFee;
606     uint256 public sellLiquidityFee;
607     uint256 public sellDevelopmentFee;
608 
609     uint256 public tokensForMarketing;
610     uint256 public tokensForLiquidity;
611     uint256 public tokensForDev;
612 
613     mapping(address => bool) private _isExcludedFromFees;
614     mapping(address => bool) public _isExcludedMaxTransactionAmount;
615 
616     mapping(address => bool) public automatedMarketMakerPairs;
617 
618     event UpdateUniswapV2Router(
619         address indexed newAddress,
620         address indexed oldAddress
621     );
622 
623     event ExcludeFromFees(address indexed account, bool isExcluded);
624 
625     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
626 
627     event marketingWalletUpdated(
628         address indexed newWallet,
629         address indexed oldWallet
630     );
631 
632     event developmentWalletUpdated(
633         address indexed newWallet,
634         address indexed oldWallet
635     );
636 
637     event SwapAndLiquify(
638         uint256 tokensSwapped,
639         uint256 ethReceived,
640         uint256 tokensIntoLiquidity
641     );
642 
643     event AutoNukeLP();
644 
645     event ManualNukeLP();
646 
647     constructor() ERC20("Hubris Coin", "HUBRIS") {
648         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
649             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
650         );
651 
652         excludeFromMaxTransaction(address(_uniswapV2Router), true);
653         uniswapV2Router = _uniswapV2Router;
654 
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
656             .createPair(address(this), _uniswapV2Router.WETH());
657         excludeFromMaxTransaction(address(uniswapV2Pair), true);
658         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
659 
660         uint256 _buyMarketingFee = 25;
661         uint256 _buyLiquidityFee = 0;
662         uint256 _buyDevelopmentFee = 0;
663 
664         uint256 _sellMarketingFee = 99;
665         uint256 _sellLiquidityFee = 0;
666         uint256 _sellDevelopmentFee = 0;
667 
668         uint256 totalSupply = 1_000_000_000 * 1e18;
669 
670         maxTransactionAmount = 1_000_000_000 * 1e18; 
671         maxWallet = 20_000_000 * 1e18; 
672         swapTokensAtAmount = (totalSupply * 10) / 10000;
673 
674         buyMarketingFee = _buyMarketingFee;
675         buyLiquidityFee = _buyLiquidityFee;
676         buyDevelopmentFee = _buyDevelopmentFee;
677         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
678 
679         sellMarketingFee = _sellMarketingFee;
680         sellLiquidityFee = _sellLiquidityFee;
681         sellDevelopmentFee = _sellDevelopmentFee;
682         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
683 
684         marketingWallet = address(0x39AA1d1a8B435A93FCCaBF7B42F3789E5238AC2E); 
685         developmentWallet = address(0x39AA1d1a8B435A93FCCaBF7B42F3789E5238AC2E); 
686 
687         excludeFromFees(owner(), true);
688         excludeFromFees(address(this), true);
689         excludeFromFees(address(0xdead), true);
690 
691         excludeFromMaxTransaction(owner(), true);
692         excludeFromMaxTransaction(address(this), true);
693         excludeFromMaxTransaction(address(0xdead), true);
694 
695         _mint(msg.sender, totalSupply);
696     }
697 
698     receive() external payable {}
699 
700     function enableTrade() external onlyOwner {
701         tradingActive = true;
702         swapEnabled = true;
703         lastLpBurnTime = block.timestamp;
704     }
705 
706     function removeLimits() external onlyOwner returns (bool) {
707         limitsInEffect = false;
708         return true;
709     }
710 
711     function disableTransferDelay() external onlyOwner returns (bool) {
712         transferDelayEnabled = false;
713         return true;
714     }
715 
716     function updateSwapTokensAtAmount(uint256 newAmount)
717         external
718         onlyOwner
719         returns (bool)
720     {
721         require(
722             newAmount >= (totalSupply() * 1) / 100000,
723             "Swap amount cannot be lower than 0.001% total supply."
724         );
725         require(
726             newAmount <= (totalSupply() * 5) / 1000,
727             "Swap amount cannot be higher than 0.5% total supply."
728         );
729         swapTokensAtAmount = newAmount;
730         return true;
731     }
732 
733     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
734         require(
735             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
736             "Cannot set maxTransactionAmount lower than 0.1%"
737         );
738         maxTransactionAmount = newNum * (10**18);
739     }
740 
741     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
742         require(
743             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
744             "Cannot set maxWallet lower than 0.5%"
745         );
746         maxWallet = newNum * (10**18);
747     }
748 
749     function excludeFromMaxTransaction(address updAds, bool isEx)
750         public
751         onlyOwner
752     {
753         _isExcludedMaxTransactionAmount[updAds] = isEx;
754     }
755 
756     function updateSwapEnabled(bool enabled) external onlyOwner {
757         swapEnabled = enabled;
758     }
759 
760     function updateBuyFees(
761         uint256 _marketingFee,
762         uint256 _liquidityFee,
763         uint256 _developmentFee
764     ) external onlyOwner {
765         buyMarketingFee = _marketingFee;
766         buyLiquidityFee = _liquidityFee;
767         buyDevelopmentFee = _developmentFee;
768         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
769     }
770 
771     function updateSellFees(
772         uint256 _marketingFee,
773         uint256 _liquidityFee,
774         uint256 _developmentFee
775     ) external onlyOwner {
776         sellMarketingFee = _marketingFee;
777         sellLiquidityFee = _liquidityFee;
778         sellDevelopmentFee = _developmentFee;
779         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
780     }
781 
782     function excludeFromFees(address account, bool excluded) public onlyOwner {
783         _isExcludedFromFees[account] = excluded;
784         emit ExcludeFromFees(account, excluded);
785     }
786 
787     function setAutomatedMarketMakerPair(address pair, bool value)
788         public
789         onlyOwner
790     {
791         require(
792             pair != uniswapV2Pair,
793             "The pair cannot be removed from automatedMarketMakerPairs"
794         );
795 
796         _setAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function _setAutomatedMarketMakerPair(address pair, bool value) private {
800         automatedMarketMakerPairs[pair] = value;
801 
802         emit SetAutomatedMarketMakerPair(pair, value);
803     }
804 
805     function updateMarketingWalletInfo(address newMarketingWallet)
806         external
807         onlyOwner
808     {
809         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
810         marketingWallet = newMarketingWallet;
811     }
812 
813     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
814         emit developmentWalletUpdated(newWallet, developmentWallet);
815         developmentWallet = newWallet;
816     }
817 
818     function isExcludedFromFees(address account) public view returns (bool) {
819         return _isExcludedFromFees[account];
820     }
821 
822     event BoughtEarly(address indexed sniper);
823 
824     function _transfer(
825         address from,
826         address to,
827         uint256 amount
828     ) internal override {
829         require(from != address(0), "ERC20: transfer from the zero address");
830         require(to != address(0), "ERC20: transfer to the zero address");
831 
832         if (amount == 0) {
833             super._transfer(from, to, 0);
834             return;
835         }
836 
837         if (limitsInEffect) {
838             if (
839                 from != owner() &&
840                 to != owner() &&
841                 to != address(0) &&
842                 to != address(0xdead) &&
843                 !swapping
844             ) {
845                 if (!tradingActive) {
846                     require(
847                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
848                         "Trading is not active."
849                     );
850                 }
851 
852                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
853                 if (transferDelayEnabled) {
854                     if (
855                         to != owner() &&
856                         to != address(uniswapV2Router) &&
857                         to != address(uniswapV2Pair)
858                     ) {
859                         require(
860                             _holderLastTransferTimestamp[tx.origin] <
861                                 block.number,
862                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
863                         );
864                         _holderLastTransferTimestamp[tx.origin] = block.number;
865                     }
866                 }
867 
868                 //when buy
869                 if (
870                     automatedMarketMakerPairs[from] &&
871                     !_isExcludedMaxTransactionAmount[to]
872                 ) {
873                     require(
874                         amount <= maxTransactionAmount,
875                         "Buy transfer amount exceeds the maxTransactionAmount."
876                     );
877                     require(
878                         amount + balanceOf(to) <= maxWallet,
879                         "Max wallet exceeded"
880                     );
881                 }
882                 //when sell
883                 else if (
884                     automatedMarketMakerPairs[to] &&
885                     !_isExcludedMaxTransactionAmount[from]
886                 ) {
887                     require(
888                         amount <= maxTransactionAmount,
889                         "Sell transfer amount exceeds the maxTransactionAmount."
890                     );
891                 } else if (!_isExcludedMaxTransactionAmount[to]) {
892                     require(
893                         amount + balanceOf(to) <= maxWallet,
894                         "Max wallet exceeded"
895                     );
896                 }
897             }
898         }
899 
900         uint256 contractTokenBalance = balanceOf(address(this));
901 
902         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
903 
904         if (
905             canSwap &&
906             swapEnabled &&
907             !swapping &&
908             !automatedMarketMakerPairs[from] &&
909             !_isExcludedFromFees[from] &&
910             !_isExcludedFromFees[to]
911         ) {
912             swapping = true;
913 
914             swapBack();
915 
916             swapping = false;
917         }
918 
919         if (
920             !swapping &&
921             automatedMarketMakerPairs[to] &&
922             lpBurnEnabled &&
923             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
924             !_isExcludedFromFees[from]
925         ) {
926             autoBurnLiquidityPairTokens();
927         }
928 
929         bool takeFee = !swapping;
930 
931         // if any account belongs to _isExcludedFromFee account then remove the fee
932         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
933             takeFee = false;
934         }
935 
936         uint256 fees = 0;
937         // only take fees on buys/sells, do not take on wallet transfers
938         if (takeFee) {
939             // on sell
940             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
941                 fees = amount.mul(sellTotalFees).div(100);
942                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
943                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
944                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
945             }
946             // on buy
947             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
948                 fees = amount.mul(buyTotalFees).div(100);
949                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
950                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
951                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
952             }
953 
954             if (fees > 0) {
955                 super._transfer(from, address(this), fees);
956             }
957 
958             amount -= fees;
959         }
960 
961         super._transfer(from, to, amount);
962     }
963 
964     function swapTokensForEth(uint256 tokenAmount) private {
965         // generate the uniswap pair path of token -> weth
966         address[] memory path = new address[](2);
967         path[0] = address(this);
968         path[1] = uniswapV2Router.WETH();
969 
970         _approve(address(this), address(uniswapV2Router), tokenAmount);
971 
972         // make the swap
973         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
974             tokenAmount,
975             0, // accept any amount of ETH
976             path,
977             address(this),
978             block.timestamp
979         );
980     }
981 
982     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
983         // approve token transfer to cover all possible scenarios
984         _approve(address(this), address(uniswapV2Router), tokenAmount);
985 
986         // add the liquidity
987         uniswapV2Router.addLiquidityETH{value: ethAmount}(
988             address(this),
989             tokenAmount,
990             0, // slippage is unavoidable
991             0, // slippage is unavoidable
992             deadAddress,
993             block.timestamp
994         );
995     }
996 
997     function swapBack() private {
998         uint256 contractBalance = balanceOf(address(this));
999         uint256 totalTokensToSwap = tokensForLiquidity +
1000             tokensForMarketing +
1001             tokensForDev;
1002         bool success;
1003 
1004         if (contractBalance == 0 || totalTokensToSwap == 0) {
1005             return;
1006         }
1007 
1008         if (contractBalance > swapTokensAtAmount * 20) {
1009             contractBalance = swapTokensAtAmount * 20;
1010         }
1011 
1012         // Halve the amount of liquidity tokens
1013         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1014             totalTokensToSwap /
1015             2;
1016         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1017 
1018         uint256 initialETHBalance = address(this).balance;
1019 
1020         swapTokensForEth(amountToSwapForETH);
1021 
1022         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1023 
1024         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1025             totalTokensToSwap
1026         );
1027         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1028 
1029         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1030 
1031         tokensForLiquidity = 0;
1032         tokensForMarketing = 0;
1033         tokensForDev = 0;
1034 
1035         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1036 
1037         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1038             addLiquidity(liquidityTokens, ethForLiquidity);
1039             emit SwapAndLiquify(
1040                 amountToSwapForETH,
1041                 ethForLiquidity,
1042                 tokensForLiquidity
1043             );
1044         }
1045 
1046         (success, ) = address(marketingWallet).call{
1047             value: address(this).balance
1048         }("");
1049     }
1050 
1051     function setAutoLPBurnSettings(
1052         uint256 _frequencyInSeconds,
1053         uint256 _percent,
1054         bool _Enabled
1055     ) external onlyOwner {
1056         require(
1057             _frequencyInSeconds >= 600,
1058             "cannot set buyback more often than every 10 minutes"
1059         );
1060         require(
1061             _percent <= 1000 && _percent >= 0,
1062             "Must set auto LP burn percent between 0% and 10%"
1063         );
1064         lpBurnFrequency = _frequencyInSeconds;
1065         percentForLPBurn = _percent;
1066         lpBurnEnabled = _Enabled;
1067     }
1068 
1069     function autoBurnLiquidityPairTokens() internal returns (bool) {
1070         lastLpBurnTime = block.timestamp;
1071 
1072         // get balance of liquidity pair
1073         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1074 
1075         // calculate amount to burn
1076         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1077             10000
1078         );
1079 
1080         // pull tokens from pancakePair liquidity and move to dead address permanently
1081         if (amountToBurn > 0) {
1082             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1083         }
1084 
1085         //sync price since this is not in a swap transaction!
1086         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1087         pair.sync();
1088         emit AutoNukeLP();
1089         return true;
1090     }
1091 
1092     function manualBurnLiquidityPairTokens(uint256 percent)
1093         external
1094         onlyOwner
1095         returns (bool)
1096     {
1097         require(
1098             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1099             "Must wait for cooldown to finish"
1100         );
1101         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1102         lastManualLpBurnTime = block.timestamp;
1103 
1104         // get balance of liquidity pair
1105         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1106 
1107         // calculate amount to burn
1108         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1109 
1110         // pull tokens from pancakePair liquidity and move to dead address permanently
1111         if (amountToBurn > 0) {
1112             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1113         }
1114 
1115         //sync price since this is not in a swap transaction!
1116         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1117         pair.sync();
1118         emit ManualNukeLP();
1119         return true;
1120     }
1121 }