1 //DAPP: https://friendfutures.app
2 //TG: https://t.me/FriendsFuturesPortal
3 //TW: https://twitter.com/FriendsFutures_
4 //DOCS: https://friend-futures.gitbook.io
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
8 pragma experimental ABIEncoderV2;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     modifier onlyOwner() {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35         _;
36     }
37 
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47 
48 
49     function _transferOwnership(address newOwner) internal virtual {
50         address oldOwner = _owner;
51         _owner = newOwner;
52         emit OwnershipTransferred(oldOwner, newOwner);
53     }
54 }
55 
56 interface IERC20 {
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62 
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65 
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70 
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99 
100     string private _name;
101     string private _symbol;
102 
103 
104     constructor(string memory name_, string memory symbol_) {
105         _name = name_;
106         _symbol = symbol_;
107     }
108 
109 
110     function name() public view virtual override returns (string memory) {
111         return _name;
112     }
113 
114 
115     function symbol() public view virtual override returns (string memory) {
116         return _symbol;
117     }
118 
119 
120     function decimals() public view virtual override returns (uint8) {
121         return 18;
122     }
123 
124 
125     function totalSupply() public view virtual override returns (uint256) {
126         return _totalSupply;
127     }
128 
129     function balanceOf(address account) public view virtual override returns (uint256) {
130         return _balances[account];
131     }
132 
133     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
134         _transfer(_msgSender(), recipient, amount);
135         return true;
136     }
137 
138 
139     function allowance(address owner, address spender) public view virtual override returns (uint256) {
140         return _allowances[owner][spender];
141     }
142 
143     function approve(address spender, uint256 amount) public virtual override returns (bool) {
144         _approve(_msgSender(), spender, amount);
145         return true;
146     }
147 
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) public virtual override returns (bool) {
153         _transfer(sender, recipient, amount);
154 
155         uint256 currentAllowance = _allowances[sender][_msgSender()];
156         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
157         unchecked {
158             _approve(sender, _msgSender(), currentAllowance - amount);
159         }
160 
161         return true;
162     }
163 
164     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
165         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
166         return true;
167     }
168 
169     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
170         uint256 currentAllowance = _allowances[_msgSender()][spender];
171         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
172         unchecked {
173             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
174         }
175 
176         return true;
177     }
178 
179     function _transfer(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) internal virtual {
184         require(sender != address(0), "ERC20: transfer from the zero address");
185         require(recipient != address(0), "ERC20: transfer to the zero address");
186 
187         _beforeTokenTransfer(sender, recipient, amount);
188 
189         uint256 senderBalance = _balances[sender];
190         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
191         unchecked {
192             _balances[sender] = senderBalance - amount;
193         }
194         _balances[recipient] += amount;
195 
196         emit Transfer(sender, recipient, amount);
197 
198         _afterTokenTransfer(sender, recipient, amount);
199     }
200 
201     function _mint(address account, uint256 amount) internal virtual {
202         require(account != address(0), "ERC20: mint to the zero address");
203 
204         _beforeTokenTransfer(address(0), account, amount);
205 
206         _totalSupply += amount;
207         _balances[account] += amount;
208         emit Transfer(address(0), account, amount);
209 
210         _afterTokenTransfer(address(0), account, amount);
211     }
212 
213     function _burn(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: burn from the zero address");
215 
216         _beforeTokenTransfer(account, address(0), amount);
217 
218         uint256 accountBalance = _balances[account];
219         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
220         unchecked {
221             _balances[account] = accountBalance - amount;
222         }
223         _totalSupply -= amount;
224 
225         emit Transfer(account, address(0), amount);
226 
227         _afterTokenTransfer(account, address(0), amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _beforeTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 
248     function _afterTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 }
254 
255 
256 library SafeMath {
257 
258     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             uint256 c = a + b;
261             if (c < a) return (false, 0);
262             return (true, c);
263         }
264     }
265 
266     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             if (b > a) return (false, 0);
269             return (true, a - b);
270         }
271     }
272 
273 
274     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (a == 0) return (true, 0);
277             uint256 c = a * b;
278             if (c / a != b) return (false, 0);
279             return (true, c);
280         }
281     }
282 
283     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             if (b == 0) return (false, 0);
286             return (true, a / b);
287         }
288     }
289 
290     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a % b);
294         }
295     }
296 
297 
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a + b;
300     }
301 
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a - b;
304     }
305 
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a * b;
308     }
309 
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a / b;
312     }
313 
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a % b;
316     }
317 
318     function sub(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b <= a, errorMessage);
325             return a - b;
326         }
327     }
328 
329     function div(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a / b;
337         }
338     }
339 
340 
341     function mod(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b > 0, errorMessage);
348             return a % b;
349         }
350     }
351 }
352 
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
384 
385 interface IUniswapV2Pair {
386     event Approval(
387         address indexed owner,
388         address indexed spender,
389         uint256 value
390     );
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     function name() external pure returns (string memory);
394 
395     function symbol() external pure returns (string memory);
396 
397     function decimals() external pure returns (uint8);
398 
399     function totalSupply() external view returns (uint256);
400 
401     function balanceOf(address owner) external view returns (uint256);
402 
403     function allowance(address owner, address spender)
404         external
405         view
406         returns (uint256);
407 
408     function approve(address spender, uint256 value) external returns (bool);
409 
410     function transfer(address to, uint256 value) external returns (bool);
411 
412     function transferFrom(
413         address from,
414         address to,
415         uint256 value
416     ) external returns (bool);
417 
418     function DOMAIN_SEPARATOR() external view returns (bytes32);
419 
420     function PERMIT_TYPEHASH() external pure returns (bytes32);
421 
422     function nonces(address owner) external view returns (uint256);
423 
424     function permit(
425         address owner,
426         address spender,
427         uint256 value,
428         uint256 deadline,
429         uint8 v,
430         bytes32 r,
431         bytes32 s
432     ) external;
433 
434     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
435     event Burn(
436         address indexed sender,
437         uint256 amount0,
438         uint256 amount1,
439         address indexed to
440     );
441     event Swap(
442         address indexed sender,
443         uint256 amount0In,
444         uint256 amount1In,
445         uint256 amount0Out,
446         uint256 amount1Out,
447         address indexed to
448     );
449     event Sync(uint112 reserve0, uint112 reserve1);
450 
451     function MINIMUM_LIQUIDITY() external pure returns (uint256);
452 
453     function factory() external view returns (address);
454 
455     function token0() external view returns (address);
456 
457     function token1() external view returns (address);
458 
459     function getReserves()
460         external
461         view
462         returns (
463             uint112 reserve0,
464             uint112 reserve1,
465             uint32 blockTimestampLast
466         );
467 
468     function price0CumulativeLast() external view returns (uint256);
469 
470     function price1CumulativeLast() external view returns (uint256);
471 
472     function kLast() external view returns (uint256);
473 
474     function mint(address to) external returns (uint256 liquidity);
475 
476     function burn(address to)
477         external
478         returns (uint256 amount0, uint256 amount1);
479 
480     function swap(
481         uint256 amount0Out,
482         uint256 amount1Out,
483         address to,
484         bytes calldata data
485     ) external;
486 
487     function skim(address to) external;
488 
489     function sync() external;
490 
491     function initialize(address, address) external;
492 }
493 
494 
495 interface IUniswapV2Router02 {
496     function factory() external pure returns (address);
497 
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint256 amountADesired,
504         uint256 amountBDesired,
505         uint256 amountAMin,
506         uint256 amountBMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         returns (
512             uint256 amountA,
513             uint256 amountB,
514             uint256 liquidity
515         );
516 
517     function addLiquidityETH(
518         address token,
519         uint256 amountTokenDesired,
520         uint256 amountTokenMin,
521         uint256 amountETHMin,
522         address to,
523         uint256 deadline
524     )
525         external
526         payable
527         returns (
528             uint256 amountToken,
529             uint256 amountETH,
530             uint256 liquidity
531         );
532 
533     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 
541     function swapExactETHForTokensSupportingFeeOnTransferTokens(
542         uint256 amountOutMin,
543         address[] calldata path,
544         address to,
545         uint256 deadline
546     ) external payable;
547 
548     function swapExactTokensForETHSupportingFeeOnTransferTokens(
549         uint256 amountIn,
550         uint256 amountOutMin,
551         address[] calldata path,
552         address to,
553         uint256 deadline
554     ) external;
555 }
556 
557 
558 contract FriendsFutures is ERC20, Ownable {
559     using SafeMath for uint256;
560 
561     IUniswapV2Router02 public immutable uniswapV2Router;
562     address public immutable uniswapV2Pair;
563     address public constant deadAddress = address(0xdead);
564 
565     bool private swapping;
566 
567     address private marketingWallet;
568     address private developmentWallet;
569 
570     uint256 public maxTransactionAmount;
571     uint256 public swapTokensAtAmount;
572     uint256 public maxWallet;
573 
574     uint256 public percentForLPBurn = 0; 
575     bool public lpBurnEnabled = false;
576     uint256 public lpBurnFrequency = 3600 seconds;
577     uint256 public lastLpBurnTime;
578 
579     uint256 public manualBurnFrequency = 30 minutes;
580     uint256 public lastManualLpBurnTime;
581 
582     bool public limitsInEffect = true;
583     bool public tradingActive = false;
584     bool public swapEnabled = true;
585 
586     mapping(address => uint256) private _holderLastTransferTimestamp; 
587     bool public transferDelayEnabled = true;
588 
589     uint256 public buyTotalFees;
590     uint256 public buyMarketingFee;
591     uint256 public buyLiquidityFee;
592     uint256 public buyDevelopmentFee;
593 
594     uint256 public sellTotalFees;
595     uint256 public sellMarketingFee;
596     uint256 public sellLiquidityFee;
597     uint256 public sellDevelopmentFee;
598 
599     uint256 public tokensForMarketing;
600     uint256 public tokensForLiquidity;
601     uint256 public tokensForDev;
602 
603     mapping(address => bool) private _isExcludedFromFees;
604     mapping(address => bool) public _isExcludedMaxTransactionAmount;
605 
606     mapping(address => bool) public automatedMarketMakerPairs;
607 
608     event UpdateUniswapV2Router(
609         address indexed newAddress,
610         address indexed oldAddress
611     );
612 
613     event ExcludeFromFees(address indexed account, bool isExcluded);
614 
615     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
616 
617     event marketingWalletUpdated(
618         address indexed newWallet,
619         address indexed oldWallet
620     );
621 
622     event developmentWalletUpdated(
623         address indexed newWallet,
624         address indexed oldWallet
625     );
626 
627     event SwapAndLiquify(
628         uint256 tokensSwapped,
629         uint256 ethReceived,
630         uint256 tokensIntoLiquidity
631     );
632 
633     event AutoNukeLP();
634 
635     event ManualNukeLP();
636 
637     constructor() ERC20("FriendFutures", "FF") {
638         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
639             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
640         );
641 
642         excludeFromMaxTransaction(address(_uniswapV2Router), true);
643         uniswapV2Router = _uniswapV2Router;
644 
645         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
646             .createPair(address(this), _uniswapV2Router.WETH());
647         excludeFromMaxTransaction(address(uniswapV2Pair), true);
648         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
649 
650         uint256 _buyMarketingFee = 30;
651         uint256 _buyLiquidityFee = 0;
652         uint256 _buyDevelopmentFee = 0;
653 
654         uint256 _sellMarketingFee = 30;
655         uint256 _sellLiquidityFee = 0;
656         uint256 _sellDevelopmentFee = 0;
657 
658         uint256 totalSupply = 100_000_000 * 1e18;
659 
660         maxTransactionAmount = 1_500_000 * 1e18;
661         maxWallet = 1_500_000 * 1e18;
662         swapTokensAtAmount = (totalSupply * 10) / 10000;
663 
664         buyMarketingFee = _buyMarketingFee;
665         buyLiquidityFee = _buyLiquidityFee;
666         buyDevelopmentFee = _buyDevelopmentFee;
667         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
668 
669         sellMarketingFee = _sellMarketingFee;
670         sellLiquidityFee = _sellLiquidityFee;
671         sellDevelopmentFee = _sellDevelopmentFee;
672         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
673 
674         marketingWallet = address(0xbF26cf2A2e8b233Bd0Ef3043093cea232397D08e); 
675         developmentWallet = address(0xbF26cf2A2e8b233Bd0Ef3043093cea232397D08e); 
676 
677         excludeFromFees(owner(), true);
678         excludeFromFees(address(this), true);
679         excludeFromFees(address(0xdead), true);
680 
681         excludeFromMaxTransaction(owner(), true);
682         excludeFromMaxTransaction(address(this), true);
683         excludeFromMaxTransaction(address(0xdead), true);
684 
685         _mint(msg.sender, totalSupply);
686     }
687 
688     receive() external payable {}
689 
690     function enableTrading() external onlyOwner {
691         tradingActive = true;
692         swapEnabled = true;
693         lastLpBurnTime = block.timestamp;
694     }
695 
696     function removeLimits() external onlyOwner returns (bool) {
697         limitsInEffect = false;
698         return true;
699     }
700 
701     function disableTransferDelay() external onlyOwner returns (bool) {
702         transferDelayEnabled = false;
703         return true;
704     }
705 
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
746     function updateSwapEnabled(bool enabled) external onlyOwner {
747         swapEnabled = enabled;
748     }
749 
750     function updateBuyFees(
751         uint256 _marketingFee,
752         uint256 _liquidityFee,
753         uint256 _developmentFee
754     ) external onlyOwner {
755         buyMarketingFee = _marketingFee;
756         buyLiquidityFee = _liquidityFee;
757         buyDevelopmentFee = _developmentFee;
758         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
759         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
760     }
761 
762     function updateSellFees(
763         uint256 _marketingFee,
764         uint256 _liquidityFee,
765         uint256 _developmentFee
766     ) external onlyOwner {
767         sellMarketingFee = _marketingFee;
768         sellLiquidityFee = _liquidityFee;
769         sellDevelopmentFee = _developmentFee;
770         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
771         require(sellTotalFees <= 90, "Must keep fees at 35% or less");
772     }
773 
774     function excludeFromFees(address account, bool excluded) public onlyOwner {
775         _isExcludedFromFees[account] = excluded;
776         emit ExcludeFromFees(account, excluded);
777     }
778 
779     function setAutomatedMarketMakerPair(address pair, bool value)
780         public
781         onlyOwner
782     {
783         require(
784             pair != uniswapV2Pair,
785             "The pair cannot be removed from automatedMarketMakerPairs"
786         );
787 
788         _setAutomatedMarketMakerPair(pair, value);
789     }
790 
791     function _setAutomatedMarketMakerPair(address pair, bool value) private {
792         automatedMarketMakerPairs[pair] = value;
793 
794         emit SetAutomatedMarketMakerPair(pair, value);
795     }
796 
797     function updateMarketingWalletInfo(address newMarketingWallet)
798         external
799         onlyOwner
800     {
801         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
802         marketingWallet = newMarketingWallet;
803     }
804 
805     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
806         emit developmentWalletUpdated(newWallet, developmentWallet);
807         developmentWallet = newWallet;
808     }
809 
810     function isExcludedFromFees(address account) public view returns (bool) {
811         return _isExcludedFromFees[account];
812     }
813 
814     event BoughtEarly(address indexed sniper);
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal override {
821         require(from != address(0), "ERC20: transfer from the zero address");
822         require(to != address(0), "ERC20: transfer to the zero address");
823 
824         if (amount == 0) {
825             super._transfer(from, to, 0);
826             return;
827         }
828 
829         if (limitsInEffect) {
830             if (
831                 from != owner() &&
832                 to != owner() &&
833                 to != address(0) &&
834                 to != address(0xdead) &&
835                 !swapping
836             ) {
837                 if (!tradingActive) {
838                     require(
839                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
840                         "Trading is not active."
841                     );
842                 }
843 
844                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
845                 if (transferDelayEnabled) {
846                     if (
847                         to != owner() &&
848                         to != address(uniswapV2Router) &&
849                         to != address(uniswapV2Pair)
850                     ) {
851                         require(
852                             _holderLastTransferTimestamp[tx.origin] <
853                                 block.number,
854                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
855                         );
856                         _holderLastTransferTimestamp[tx.origin] = block.number;
857                     }
858                 }
859 
860                 //when buy
861                 if (
862                     automatedMarketMakerPairs[from] &&
863                     !_isExcludedMaxTransactionAmount[to]
864                 ) {
865                     require(
866                         amount <= maxTransactionAmount,
867                         "Buy transfer amount exceeds the maxTransactionAmount."
868                     );
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max wallet exceeded"
872                     );
873                 }
874                 //when sell
875                 else if (
876                     automatedMarketMakerPairs[to] &&
877                     !_isExcludedMaxTransactionAmount[from]
878                 ) {
879                     require(
880                         amount <= maxTransactionAmount,
881                         "Sell transfer amount exceeds the maxTransactionAmount."
882                     );
883                 } else if (!_isExcludedMaxTransactionAmount[to]) {
884                     require(
885                         amount + balanceOf(to) <= maxWallet,
886                         "Max wallet exceeded"
887                     );
888                 }
889             }
890         }
891 
892         uint256 contractTokenBalance = balanceOf(address(this));
893 
894         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
895 
896         if (
897             canSwap &&
898             swapEnabled &&
899             !swapping &&
900             !automatedMarketMakerPairs[from] &&
901             !_isExcludedFromFees[from] &&
902             !_isExcludedFromFees[to]
903         ) {
904             swapping = true;
905 
906             swapBack();
907 
908             swapping = false;
909         }
910 
911         if (
912             !swapping &&
913             automatedMarketMakerPairs[to] &&
914             lpBurnEnabled &&
915             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
916             !_isExcludedFromFees[from]
917         ) {
918             autoBurnLiquidityPairTokens();
919         }
920 
921         bool takeFee = !swapping;
922 
923         // if any account belongs to _isExcludedFromFee account then remove the fee
924         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
925             takeFee = false;
926         }
927 
928         uint256 fees = 0;
929         // only take fees on buys/sells, do not take on wallet transfers
930         if (takeFee) {
931             // on sell
932             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
933                 fees = amount.mul(sellTotalFees).div(100);
934                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
935                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
936                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
937             }
938             // on buy
939             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
940                 fees = amount.mul(buyTotalFees).div(100);
941                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
942                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
943                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
944             }
945 
946             if (fees > 0) {
947                 super._transfer(from, address(this), fees);
948             }
949 
950             amount -= fees;
951         }
952 
953         super._transfer(from, to, amount);
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
974     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
975         // approve token transfer to cover all possible scenarios
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // add the liquidity
979         uniswapV2Router.addLiquidityETH{value: ethAmount}(
980             address(this),
981             tokenAmount,
982             0, // slippage is unavoidable
983             0, // slippage is unavoidable
984             deadAddress,
985             block.timestamp
986         );
987     }
988 
989     function swapBack() private {
990         uint256 contractBalance = balanceOf(address(this));
991         uint256 totalTokensToSwap = tokensForLiquidity +
992             tokensForMarketing +
993             tokensForDev;
994         bool success;
995 
996         if (contractBalance == 0 || totalTokensToSwap == 0) {
997             return;
998         }
999 
1000         if (contractBalance > swapTokensAtAmount * 20) {
1001             contractBalance = swapTokensAtAmount * 20;
1002         }
1003 
1004         // Halve the amount of liquidity tokens
1005         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1006             totalTokensToSwap /
1007             2;
1008         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1009 
1010         uint256 initialETHBalance = address(this).balance;
1011 
1012         swapTokensForEth(amountToSwapForETH);
1013 
1014         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1015 
1016         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1017             totalTokensToSwap
1018         );
1019         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1020 
1021         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1022 
1023         tokensForLiquidity = 0;
1024         tokensForMarketing = 0;
1025         tokensForDev = 0;
1026 
1027         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1028 
1029         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1030             addLiquidity(liquidityTokens, ethForLiquidity);
1031             emit SwapAndLiquify(
1032                 amountToSwapForETH,
1033                 ethForLiquidity,
1034                 tokensForLiquidity
1035             );
1036         }
1037 
1038         (success, ) = address(marketingWallet).call{
1039             value: address(this).balance
1040         }("");
1041     }
1042 
1043     function setAutoLPBurnSettings(
1044         uint256 _frequencyInSeconds,
1045         uint256 _percent,
1046         bool _Enabled
1047     ) external onlyOwner {
1048         require(
1049             _frequencyInSeconds >= 600,
1050             "cannot set buyback more often than every 10 minutes"
1051         );
1052         require(
1053             _percent <= 1000 && _percent >= 0,
1054             "Must set auto LP burn percent between 0% and 10%"
1055         );
1056         lpBurnFrequency = _frequencyInSeconds;
1057         percentForLPBurn = _percent;
1058         lpBurnEnabled = _Enabled;
1059     }
1060 
1061     function autoBurnLiquidityPairTokens() internal returns (bool) {
1062         lastLpBurnTime = block.timestamp;
1063 
1064         // get balance of liquidity pair
1065         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1066 
1067         // calculate amount to burn
1068         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1069             10000
1070         );
1071 
1072         // pull tokens from pancakePair liquidity and move to dead address permanently
1073         if (amountToBurn > 0) {
1074             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1075         }
1076 
1077         //sync price since this is not in a swap transaction!
1078         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1079         pair.sync();
1080         emit AutoNukeLP();
1081         return true;
1082     }
1083 
1084     function manualBurnLiquidityPairTokens(uint256 percent)
1085         external
1086         onlyOwner
1087         returns (bool)
1088     {
1089         require(
1090             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1091             "Must wait for cooldown to finish"
1092         );
1093         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1094         lastManualLpBurnTime = block.timestamp;
1095 
1096         // get balance of liquidity pair
1097         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1098 
1099         // calculate amount to burn
1100         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1101 
1102         // pull tokens from pancakePair liquidity and move to dead address permanently
1103         if (amountToBurn > 0) {
1104             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1105         }
1106 
1107         //sync price since this is not in a swap transaction!
1108         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1109         pair.sync();
1110         emit ManualNukeLP();
1111         return true;
1112     }
1113 }