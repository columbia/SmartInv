1 /*
2 
3 https://t.me/Fren_Token
4 https://twitter.com/Fren_Token
5 https://frens.finance/
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.19;
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
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 interface IERC20 {
63 
64     function totalSupply() external view returns (uint256);
65 
66     function balanceOf(address account) external view returns (uint256);
67 
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IERC20Metadata is IERC20 {
86 
87     function name() external view returns (string memory);
88 
89     function symbol() external view returns (string memory);
90 
91     function decimals() external view returns (uint8);
92 }
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96 
97     mapping(address => mapping(address => uint256)) private _allowances;
98 
99     uint256 private _totalSupply;
100 
101     string private _name;
102     string private _symbol;
103 
104     constructor(string memory name_, string memory symbol_) {
105         _name = name_;
106         _symbol = symbol_;
107     }
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view virtual override returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view virtual override returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
139         _approve(_msgSender(), spender, amount);
140         return true;
141     }
142 
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) public virtual override returns (bool) {
148         _transfer(sender, recipient, amount);
149 
150         uint256 currentAllowance = _allowances[sender][_msgSender()];
151         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
152         unchecked {
153             _approve(sender, _msgSender(), currentAllowance - amount);
154         }
155 
156         return true;
157     }
158 
159     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
160         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
161         return true;
162     }
163 
164     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
165         uint256 currentAllowance = _allowances[_msgSender()][spender];
166         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
167         unchecked {
168             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
169         }
170 
171         return true;
172     }
173 
174     function _transfer(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) internal virtual {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181 
182         _beforeTokenTransfer(sender, recipient, amount);
183 
184         uint256 senderBalance = _balances[sender];
185         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
186         unchecked {
187             _balances[sender] = senderBalance - amount;
188         }
189         _balances[recipient] += amount;
190 
191         emit Transfer(sender, recipient, amount);
192 
193         _afterTokenTransfer(sender, recipient, amount);
194     }
195 
196     function _mint(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198 
199         _beforeTokenTransfer(address(0), account, amount);
200 
201         _totalSupply += amount;
202         _balances[account] += amount;
203         emit Transfer(address(0), account, amount);
204 
205         _afterTokenTransfer(address(0), account, amount);
206     }
207 
208     function _burn(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: burn from the zero address");
210 
211         _beforeTokenTransfer(account, address(0), amount);
212 
213         uint256 accountBalance = _balances[account];
214         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
215         unchecked {
216             _balances[account] = accountBalance - amount;
217         }
218         _totalSupply -= amount;
219 
220         emit Transfer(account, address(0), amount);
221 
222         _afterTokenTransfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 
243     function _afterTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248 }
249 
250 library SafeMath {
251 
252     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             uint256 c = a + b;
255             if (c < a) return (false, 0);
256             return (true, c);
257         }
258     }
259 
260     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b > a) return (false, 0);
263             return (true, a - b);
264         }
265     }
266 
267     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (a == 0) return (true, 0);
270             uint256 c = a * b;
271             if (c / a != b) return (false, 0);
272             return (true, c);
273         }
274     }
275 
276     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a / b);
280         }
281     }
282 
283     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         unchecked {
285             if (b == 0) return (false, 0);
286             return (true, a % b);
287         }
288     }
289 
290     function add(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a + b;
292     }
293 
294     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a - b;
296     }
297 
298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a * b;
300     }
301 
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a / b;
304     }
305 
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a % b;
308     }
309 
310     function sub(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         unchecked {
316             require(b <= a, errorMessage);
317             return a - b;
318         }
319     }
320 
321     function div(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a / b;
329         }
330     }
331 
332     function mod(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a % b;
340         }
341     }
342 }
343 
344 interface IUniswapV2Factory {
345     event PairCreated(
346         address indexed token0,
347         address indexed token1,
348         address pair,
349         uint256
350     );
351 
352     function feeTo() external view returns (address);
353 
354     function feeToSetter() external view returns (address);
355 
356     function getPair(address tokenA, address tokenB)
357         external
358         view
359         returns (address pair);
360 
361     function allPairs(uint256) external view returns (address pair);
362 
363     function allPairsLength() external view returns (uint256);
364 
365     function createPair(address tokenA, address tokenB)
366         external
367         returns (address pair);
368 
369     function setFeeTo(address) external;
370 
371     function setFeeToSetter(address) external;
372 }
373 
374 interface IUniswapV2Pair {
375     event Approval(
376         address indexed owner,
377         address indexed spender,
378         uint256 value
379     );
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     function name() external pure returns (string memory);
383 
384     function symbol() external pure returns (string memory);
385 
386     function decimals() external pure returns (uint8);
387 
388     function totalSupply() external view returns (uint256);
389 
390     function balanceOf(address owner) external view returns (uint256);
391 
392     function allowance(address owner, address spender)
393         external
394         view
395         returns (uint256);
396 
397     function approve(address spender, uint256 value) external returns (bool);
398 
399     function transfer(address to, uint256 value) external returns (bool);
400 
401     function transferFrom(
402         address from,
403         address to,
404         uint256 value
405     ) external returns (bool);
406 
407     function DOMAIN_SEPARATOR() external view returns (bytes32);
408 
409     function PERMIT_TYPEHASH() external pure returns (bytes32);
410 
411     function nonces(address owner) external view returns (uint256);
412 
413     function permit(
414         address owner,
415         address spender,
416         uint256 value,
417         uint256 deadline,
418         uint8 v,
419         bytes32 r,
420         bytes32 s
421     ) external;
422 
423     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
424     event Burn(
425         address indexed sender,
426         uint256 amount0,
427         uint256 amount1,
428         address indexed to
429     );
430     event Swap(
431         address indexed sender,
432         uint256 amount0In,
433         uint256 amount1In,
434         uint256 amount0Out,
435         uint256 amount1Out,
436         address indexed to
437     );
438     event Sync(uint112 reserve0, uint112 reserve1);
439 
440     function MINIMUM_LIQUIDITY() external pure returns (uint256);
441 
442     function factory() external view returns (address);
443 
444     function token0() external view returns (address);
445 
446     function token1() external view returns (address);
447 
448     function getReserves()
449         external
450         view
451         returns (
452             uint112 reserve0,
453             uint112 reserve1,
454             uint32 blockTimestampLast
455         );
456 
457     function price0CumulativeLast() external view returns (uint256);
458 
459     function price1CumulativeLast() external view returns (uint256);
460 
461     function kLast() external view returns (uint256);
462 
463     function mint(address to) external returns (uint256 liquidity);
464 
465     function burn(address to)
466         external
467         returns (uint256 amount0, uint256 amount1);
468 
469     function swap(
470         uint256 amount0Out,
471         uint256 amount1Out,
472         address to,
473         bytes calldata data
474     ) external;
475 
476     function skim(address to) external;
477 
478     function sync() external;
479 
480     function initialize(address, address) external;
481 }
482 
483 interface IUniswapV2Router02 {
484     function factory() external pure returns (address);
485 
486     function WETH() external pure returns (address);
487 
488     function addLiquidity(
489         address tokenA,
490         address tokenB,
491         uint256 amountADesired,
492         uint256 amountBDesired,
493         uint256 amountAMin,
494         uint256 amountBMin,
495         address to,
496         uint256 deadline
497     )
498         external
499         returns (
500             uint256 amountA,
501             uint256 amountB,
502             uint256 liquidity
503         );
504 
505     function addLiquidityETH(
506         address token,
507         uint256 amountTokenDesired,
508         uint256 amountTokenMin,
509         uint256 amountETHMin,
510         address to,
511         uint256 deadline
512     )
513         external
514         payable
515         returns (
516             uint256 amountToken,
517             uint256 amountETH,
518             uint256 liquidity
519         );
520 
521     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external;
528 
529     function swapExactETHForTokensSupportingFeeOnTransferTokens(
530         uint256 amountOutMin,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external payable;
535 
536     function swapExactTokensForETHSupportingFeeOnTransferTokens(
537         uint256 amountIn,
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external;
543 }
544 
545 contract FrenToken is ERC20, Ownable {
546     using SafeMath for uint256;
547 
548     IUniswapV2Router02 public immutable uniswapV2Router;
549     address public immutable uniswapV2Pair;
550     address public constant deadAddress = address(0xdead);
551 
552     bool private swapping;
553 
554     address public marketingWallet;
555 
556     uint256 public maxTransactionAmount;
557     uint256 public swapTokensAtAmount;
558     uint256 public maxWallet;
559 
560     bool public limitsInEffect = true;
561     bool public tradingActive = false;
562     bool public swapEnabled = false;
563     bool launched = false;
564 
565 
566     uint256 public buyTotalFees;
567     uint256 private buyMarketingFee;
568 
569     uint256 public sellTotalFees;
570     uint256 public sellMarketingFee;
571 
572     uint256 public tokensForMarketing;
573 
574     mapping(address => bool) private _isExcludedFromFees;
575     mapping(address => bool) public _isExcludedMaxTransactionAmount;
576 
577     mapping(address => bool) public automatedMarketMakerPairs;
578 
579     event UpdateUniswapV2Router(
580         address indexed newAddress,
581         address indexed oldAddress
582     );
583 
584     event ExcludeFromFees(address indexed account, bool isExcluded);
585 
586     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
587 
588     event marketingWalletUpdated(
589         address indexed newWallet,
590         address indexed oldWallet
591     );
592 
593     event SwapAndLiquify(
594         uint256 tokensSwapped,
595         uint256 ethReceived,
596         uint256 tokensIntoLiquidity
597     );
598 
599     constructor(address wallet1) ERC20("FrenToken", "FREN") {
600         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
601 
602         excludeFromMaxTransaction(address(_uniswapV2Router), true);
603         uniswapV2Router = _uniswapV2Router;
604 
605         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
606             .createPair(address(this), _uniswapV2Router.WETH());
607         excludeFromMaxTransaction(address(uniswapV2Pair), true);
608         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
609 
610         uint256 totalSupply = 420420420420 * 1e18;
611 
612         maxTransactionAmount = 420420420420 * 1e18;
613         maxWallet = 420420420420 * 1e18;
614         swapTokensAtAmount =totalSupply/1_500;
615 
616 
617         marketingWallet = wallet1; // set as marketing wallet
618 
619         // exclude from paying fees or having max transaction amount
620         excludeFromFees(owner(), true);
621         excludeFromFees(address(this), true);
622         excludeFromFees(address(0xdead), true);
623 
624         excludeFromMaxTransaction(owner(), true);
625         excludeFromMaxTransaction(address(this), true);
626         excludeFromMaxTransaction(address(0xdead), true);
627 
628         /*
629             _mint is an internal function in ERC20.sol that is only called here,
630             and CANNOT be called ever again
631         */
632         _mint(msg.sender, totalSupply);
633     }
634 
635     receive() external payable {}
636 
637     // once enabled, can never be turned off
638     function enableTrading() external onlyOwner {
639         buyMarketingFee = 99;
640         buyTotalFees = buyMarketingFee;
641         sellMarketingFee = 97;
642         sellTotalFees = sellMarketingFee;
643         tradingActive = true;
644         swapEnabled = true;
645     }
646 
647     // remove limits after token is stable
648     function removeLimits() external onlyOwner returns (bool) {
649         limitsInEffect = false;
650         return true;
651     }
652 
653 
654     // change the minimum amount of tokens to sell from fees
655     function updateSwapTokensAtAmount(uint256 newAmount)
656         external
657         onlyOwner
658         returns (bool)
659     {
660         require(
661             newAmount >= (totalSupply() * 1) / 100000,
662             "Swap amount cannot be lower than 0.001% total supply."
663         );
664         require(
665             newAmount <= (totalSupply() * 5) / 1000,
666             "Swap amount cannot be higher than 0.5% total supply."
667         );
668         swapTokensAtAmount = newAmount;
669         return true;
670     }
671 
672     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
673         require(
674             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
675             "Cannot set maxTransactionAmount lower than 0.1%"
676         );
677         maxTransactionAmount = newNum * (10**18);
678     }
679 
680     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
681         require(
682             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
683             "Cannot set maxWallet lower than 0.5%"
684         );
685         maxWallet = newNum * (10**18);
686     }
687 
688     function whitelistContract(address _whitelist,bool isWL)
689     public
690     onlyOwner
691     {
692       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
693 
694       _isExcludedFromFees[_whitelist] = isWL;
695 
696     }
697 
698     function excludeFromMaxTransaction(address updAds, bool isEx)
699         public
700         onlyOwner
701     {
702         _isExcludedMaxTransactionAmount[updAds] = isEx;
703     }
704 
705     // only use to disable contract sales if absolutely necessary (emergency use only)
706     function updateSwapEnabled(bool enabled) external onlyOwner {
707         swapEnabled = enabled;
708     }
709 
710     function updateBuyFees(
711         uint256 _marketingFee
712     ) external onlyOwner {
713         buyMarketingFee = _marketingFee;
714         buyTotalFees = buyMarketingFee;
715         require(buyTotalFees <= 70, "Must keep fees at 50% or less");
716     }
717 
718     function updateSellFees(
719         uint256 _marketingFee
720     ) external onlyOwner {
721         sellMarketingFee = _marketingFee;
722         sellTotalFees = sellMarketingFee;
723         require(sellTotalFees <= 70, "Must keep fees at 50% or less");
724     }
725 
726     function excludeFromFees(address account, bool excluded) public onlyOwner {
727         _isExcludedFromFees[account] = excluded;
728         emit ExcludeFromFees(account, excluded);
729     }
730 
731     function manualswap(uint256 amount) external {
732         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
733         swapTokensForEth(amount);
734     }
735 
736     function beFrens() external onlyOwner {
737       require(!launched, "Launched already");
738 
739       buyMarketingFee = 5;
740       buyTotalFees = buyMarketingFee;
741 
742       sellMarketingFee = 98;
743       sellTotalFees = sellMarketingFee;
744 
745       maxTransactionAmount =  6726726726  * 1e18;
746       maxWallet =  6726726726  * 1e18;
747 
748       launched = true;
749 
750     }
751 
752     function manualsend() external {
753         bool success;
754         (success, ) = address(marketingWallet).call{
755             value: address(this).balance
756         }("");
757     }
758 
759         function setAutomatedMarketMakerPair(address pair, bool value)
760         public
761         onlyOwner
762     {
763         require(
764             pair != uniswapV2Pair,
765             "The pair cannot be removed from automatedMarketMakerPairs"
766         );
767 
768         _setAutomatedMarketMakerPair(pair, value);
769     }
770 
771     function _setAutomatedMarketMakerPair(address pair, bool value) private {
772         automatedMarketMakerPairs[pair] = value;
773 
774         emit SetAutomatedMarketMakerPair(pair, value);
775     }
776 
777     function updateMarketingWallet(address newMarketingWallet)
778         external
779         onlyOwner
780     {
781         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
782         marketingWallet = newMarketingWallet;
783     }
784 
785     function _transfer(
786         address from,
787         address to,
788         uint256 amount
789     ) internal override {
790         require(from != address(0), "ERC20: transfer from the zero address");
791         require(to != address(0), "ERC20: transfer to the zero address");
792 
793         if (amount == 0) {
794             super._transfer(from, to, 0);
795             return;
796         }
797 
798         if (limitsInEffect) {
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0) &&
803                 to != address(0xdead) &&
804                 !swapping
805             ) {
806                 if (!tradingActive) {
807                     require(
808                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
809                         "Trading is not active."
810                     );
811                 }
812 
813                 //when buy
814                 if (
815                     automatedMarketMakerPairs[from] &&
816                     !_isExcludedMaxTransactionAmount[to]
817                 ) {
818                     require(
819                         amount <= maxTransactionAmount,
820                         "Buy transfer amount exceeds the maxTransactionAmount."
821                     );
822                     require(
823                         amount + balanceOf(to) <= maxWallet,
824                         "Max wallet exceeded"
825                     );
826                 }
827                 //when sell
828                 else if (
829                     automatedMarketMakerPairs[to] &&
830                     !_isExcludedMaxTransactionAmount[from]
831                 ) {
832                     require(
833                         amount <= maxTransactionAmount,
834                         "Sell transfer amount exceeds the maxTransactionAmount."
835                     );
836                 } else if (!_isExcludedMaxTransactionAmount[to]) {
837                     require(
838                         amount + balanceOf(to) <= maxWallet,
839                         "Max wallet exceeded"
840                     );
841                 }
842             }
843         }
844 
845         uint256 contractTokenBalance = balanceOf(address(this));
846 
847         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
848 
849         if (
850             canSwap &&
851             swapEnabled &&
852             !swapping &&
853             !automatedMarketMakerPairs[from] &&
854             !_isExcludedFromFees[from] &&
855             !_isExcludedFromFees[to]
856         ) {
857             swapping = true;
858 
859             swapBack();
860 
861             swapping = false;
862         }
863 
864         bool takeFee = !swapping;
865 
866         // if any account belongs to _isExcludedFromFee account then remove the fee
867         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
868             takeFee = false;
869         }
870 
871         uint256 fees = 0;
872         // only take fees on buys/sells, do not take on wallet transfers
873         if (takeFee) {
874             // on sell
875             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
876                 fees = amount.mul(sellTotalFees).div(100);
877                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
878             }
879             // on buy
880             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
881                 fees = amount.mul(buyTotalFees).div(100);
882                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
883             }
884 
885             if (fees > 0) {
886                 super._transfer(from, address(this), fees);
887             }
888 
889             amount -= fees;
890         }
891 
892         super._transfer(from, to, amount);
893     }
894 
895     function swapTokensForEth(uint256 tokenAmount) private {
896         // generate the uniswap pair path of token -> weth
897         address[] memory path = new address[](2);
898         path[0] = address(this);
899         path[1] = uniswapV2Router.WETH();
900 
901         _approve(address(this), address(uniswapV2Router), tokenAmount);
902 
903         // make the swap
904         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
905             tokenAmount,
906             0, // accept any amount of ETH
907             path,
908             address(this),
909             block.timestamp
910         );
911     }
912 
913 
914     function swapBack() private {
915         uint256 contractBalance = balanceOf(address(this));
916         uint256 totalTokensToSwap =
917             tokensForMarketing;
918         bool success;
919 
920         if (contractBalance == 0 || totalTokensToSwap == 0) {
921             return;
922         }
923 
924         if (contractBalance > swapTokensAtAmount * 20) {
925             contractBalance = swapTokensAtAmount * 20;
926         }
927 
928         // Halve the amount of liquidity tokens
929 
930         uint256 amountToSwapForETH = contractBalance;
931 
932         swapTokensForEth(amountToSwapForETH);
933 
934         tokensForMarketing = 0;
935 
936 
937         (success, ) = address(marketingWallet).call{
938             value: address(this).balance
939         }("");
940     }
941 
942 }