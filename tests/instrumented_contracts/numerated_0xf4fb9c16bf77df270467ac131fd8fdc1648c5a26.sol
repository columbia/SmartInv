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
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
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
43     
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48 
49     
50     function _transferOwnership(address newOwner) internal virtual {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56 
57 
58 interface IERC20 {
59     
60     function totalSupply() external view returns (uint256);
61 
62     
63     function balanceOf(address account) external view returns (uint256);
64 
65     
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 interface IERC20Metadata is IERC20 {
90     
91     function name() external view returns (string memory);
92 
93    
94     function symbol() external view returns (string memory);
95 
96     
97     function decimals() external view returns (uint8);
98 }
99 
100 
101 
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
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
138     
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     
144     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
145         _transfer(_msgSender(), recipient, amount);
146         return true;
147     }
148 
149     
150     function allowance(address owner, address spender) public view virtual override returns (uint256) {
151         return _allowances[owner][spender];
152     }
153 
154     
155     function approve(address spender, uint256 amount) public virtual override returns (bool) {
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
170         unchecked {
171             _approve(sender, _msgSender(), currentAllowance - amount);
172         }
173 
174         return true;
175     }
176 
177     
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
180         return true;
181     }
182 
183    
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
187         unchecked {
188             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
189         }
190 
191         return true;
192     }
193 
194     
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         _beforeTokenTransfer(sender, recipient, amount);
204 
205         uint256 senderBalance = _balances[sender];
206         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
207         unchecked {
208             _balances[sender] = senderBalance - amount;
209         }
210         _balances[recipient] += amount;
211 
212         emit Transfer(sender, recipient, amount);
213 
214         _afterTokenTransfer(sender, recipient, amount);
215     }
216 
217     
218     function _mint(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _beforeTokenTransfer(address(0), account, amount);
222 
223         _totalSupply += amount;
224         _balances[account] += amount;
225         emit Transfer(address(0), account, amount);
226 
227         _afterTokenTransfer(address(0), account, amount);
228     }
229 
230    
231     function _burn(address account, uint256 amount) internal virtual {
232         require(account != address(0), "ERC20: burn from the zero address");
233 
234         _beforeTokenTransfer(account, address(0), amount);
235 
236         uint256 accountBalance = _balances[account];
237         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
238         unchecked {
239             _balances[account] = accountBalance - amount;
240         }
241         _totalSupply -= amount;
242 
243         emit Transfer(account, address(0), amount);
244 
245         _afterTokenTransfer(account, address(0), amount);
246     }
247 
248     
249     function _approve(
250         address owner,
251         address spender,
252         uint256 amount
253     ) internal virtual {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256 
257         _allowances[owner][spender] = amount;
258         emit Approval(owner, spender, amount);
259     }
260 
261     
262     function _beforeTokenTransfer(
263         address from,
264         address to,
265         uint256 amount
266     ) internal virtual {}
267 
268    
269     function _afterTokenTransfer(
270         address from,
271         address to,
272         uint256 amount
273     ) internal virtual {}
274 }
275 
276 
277 library SafeMath {
278     
279     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             uint256 c = a + b;
282             if (c < a) return (false, 0);
283             return (true, c);
284         }
285     }
286 
287     
288     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b > a) return (false, 0);
291             return (true, a - b);
292         }
293     }
294 
295    
296     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299             // benefit is lost if 'b' is also tested.
300             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301             if (a == 0) return (true, 0);
302             uint256 c = a * b;
303             if (c / a != b) return (false, 0);
304             return (true, c);
305         }
306     }
307 
308     
309     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
310         unchecked {
311             if (b == 0) return (false, 0);
312             return (true, a / b);
313         }
314     }
315 
316     
317     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
318         unchecked {
319             if (b == 0) return (false, 0);
320             return (true, a % b);
321         }
322     }
323 
324     
325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a + b;
327     }
328 
329     
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a - b;
332     }
333 
334     
335     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a * b;
337     }
338 
339     
340     function div(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a / b;
342     }
343 
344     
345     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a % b;
347     }
348 
349     
350     function sub(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b <= a, errorMessage);
357             return a - b;
358         }
359     }
360 
361     
362     function div(
363         uint256 a,
364         uint256 b,
365         string memory errorMessage
366     ) internal pure returns (uint256) {
367         unchecked {
368             require(b > 0, errorMessage);
369             return a / b;
370         }
371     }
372 
373     
374     function mod(
375         uint256 a,
376         uint256 b,
377         string memory errorMessage
378     ) internal pure returns (uint256) {
379         unchecked {
380             require(b > 0, errorMessage);
381             return a % b;
382         }
383     }
384 }
385 
386 /* pragma solidity 0.8.10; */
387 /* pragma experimental ABIEncoderV2; */
388 
389 interface IUniswapV2Factory {
390     event PairCreated(
391         address indexed token0,
392         address indexed token1,
393         address pair,
394         uint256
395     );
396 
397     function feeTo() external view returns (address);
398 
399     function feeToSetter() external view returns (address);
400 
401     function getPair(address tokenA, address tokenB)
402         external
403         view
404         returns (address pair);
405 
406     function allPairs(uint256) external view returns (address pair);
407 
408     function allPairsLength() external view returns (uint256);
409 
410     function createPair(address tokenA, address tokenB)
411         external
412         returns (address pair);
413 
414     function setFeeTo(address) external;
415 
416     function setFeeToSetter(address) external;
417 }
418 
419 /* pragma solidity 0.8.10; */
420 /* pragma experimental ABIEncoderV2; */
421 
422 interface IUniswapV2Pair {
423     event Approval(
424         address indexed owner,
425         address indexed spender,
426         uint256 value
427     );
428     event Transfer(address indexed from, address indexed to, uint256 value);
429 
430     function name() external pure returns (string memory);
431 
432     function symbol() external pure returns (string memory);
433 
434     function decimals() external pure returns (uint8);
435 
436     function totalSupply() external view returns (uint256);
437 
438     function balanceOf(address owner) external view returns (uint256);
439 
440     function allowance(address owner, address spender)
441         external
442         view
443         returns (uint256);
444 
445     function approve(address spender, uint256 value) external returns (bool);
446 
447     function transfer(address to, uint256 value) external returns (bool);
448 
449     function transferFrom(
450         address from,
451         address to,
452         uint256 value
453     ) external returns (bool);
454 
455     function DOMAIN_SEPARATOR() external view returns (bytes32);
456 
457     function PERMIT_TYPEHASH() external pure returns (bytes32);
458 
459     function nonces(address owner) external view returns (uint256);
460 
461     function permit(
462         address owner,
463         address spender,
464         uint256 value,
465         uint256 deadline,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) external;
470 
471     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
472     event Burn(
473         address indexed sender,
474         uint256 amount0,
475         uint256 amount1,
476         address indexed to
477     );
478     event Swap(
479         address indexed sender,
480         uint256 amount0In,
481         uint256 amount1In,
482         uint256 amount0Out,
483         uint256 amount1Out,
484         address indexed to
485     );
486     event Sync(uint112 reserve0, uint112 reserve1);
487 
488     function MINIMUM_LIQUIDITY() external pure returns (uint256);
489 
490     function factory() external view returns (address);
491 
492     function token0() external view returns (address);
493 
494     function token1() external view returns (address);
495 
496     function getReserves()
497         external
498         view
499         returns (
500             uint112 reserve0,
501             uint112 reserve1,
502             uint32 blockTimestampLast
503         );
504 
505     function price0CumulativeLast() external view returns (uint256);
506 
507     function price1CumulativeLast() external view returns (uint256);
508 
509     function kLast() external view returns (uint256);
510 
511     function mint(address to) external returns (uint256 liquidity);
512 
513     function burn(address to)
514         external
515         returns (uint256 amount0, uint256 amount1);
516 
517     function swap(
518         uint256 amount0Out,
519         uint256 amount1Out,
520         address to,
521         bytes calldata data
522     ) external;
523 
524     function skim(address to) external;
525 
526     function sync() external;
527 
528     function initialize(address, address) external;
529 }
530 
531 /* pragma solidity 0.8.10; */
532 /* pragma experimental ABIEncoderV2; */
533 
534 interface IUniswapV2Router02 {
535     function factory() external pure returns (address);
536 
537     function WETH() external pure returns (address);
538 
539     function addLiquidity(
540         address tokenA,
541         address tokenB,
542         uint256 amountADesired,
543         uint256 amountBDesired,
544         uint256 amountAMin,
545         uint256 amountBMin,
546         address to,
547         uint256 deadline
548     )
549         external
550         returns (
551             uint256 amountA,
552             uint256 amountB,
553             uint256 liquidity
554         );
555 
556     function addLiquidityETH(
557         address token,
558         uint256 amountTokenDesired,
559         uint256 amountTokenMin,
560         uint256 amountETHMin,
561         address to,
562         uint256 deadline
563     )
564         external
565         payable
566         returns (
567             uint256 amountToken,
568             uint256 amountETH,
569             uint256 liquidity
570         );
571 
572     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
573         uint256 amountIn,
574         uint256 amountOutMin,
575         address[] calldata path,
576         address to,
577         uint256 deadline
578     ) external;
579 
580     function swapExactETHForTokensSupportingFeeOnTransferTokens(
581         uint256 amountOutMin,
582         address[] calldata path,
583         address to,
584         uint256 deadline
585     ) external payable;
586 
587     function swapExactTokensForETHSupportingFeeOnTransferTokens(
588         uint256 amountIn,
589         uint256 amountOutMin,
590         address[] calldata path,
591         address to,
592         uint256 deadline
593     ) external;
594 }
595 
596 
597 
598 contract QUACK is ERC20, Ownable {
599     using SafeMath for uint256;
600 
601     IUniswapV2Router02 public immutable uniswapV2Router;
602     address public immutable uniswapV2Pair;
603     address public constant deadAddress = address(0xdead);
604 
605     bool private swapping;
606 
607     address public devWallet;
608 
609     uint256 public maxTransactionAmount;
610     uint256 public swapTokensAtAmount;
611     uint256 public maxWallet;
612 
613     bool public limitsInEffect = true;
614     bool public tradingActive = false;
615     bool public swapEnabled = false;
616 
617     uint256 public buyTotalFees;
618     uint256 public buyLiquidityFee;
619     uint256 public buyDevFee;
620 
621     uint256 public sellTotalFees;
622     uint256 public sellLiquidityFee;
623     uint256 public sellDevFee;
624 
625 	uint256 public tokensForLiquidity;
626     uint256 public tokensForDev;
627 
628     /******************/
629 
630     // exlcude from fees and max transaction amount
631     mapping(address => bool) private _isExcludedFromFees;
632     mapping(address => bool) public _isExcludedMaxTransactionAmount;
633 
634     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
635     // could be subject to a maximum transfer amount
636     mapping(address => bool) public automatedMarketMakerPairs;
637 
638     event UpdateUniswapV2Router(
639         address indexed newAddress,
640         address indexed oldAddress
641     );
642 
643     event ExcludeFromFees(address indexed account, bool isExcluded);
644 
645     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
646 
647     event SwapAndLiquify(
648         uint256 tokensSwapped,
649         uint256 ethReceived,
650         uint256 tokensIntoLiquidity
651     );
652 
653     constructor() ERC20("Return of the Quack", "QUACK") {
654         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
655             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
656         );
657 
658         excludeFromMaxTransaction(address(_uniswapV2Router), true);
659         uniswapV2Router = _uniswapV2Router;
660 
661         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
662             .createPair(address(this), _uniswapV2Router.WETH());
663         excludeFromMaxTransaction(address(uniswapV2Pair), true);
664         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
665 
666         uint256 _buyLiquidityFee = 0;
667         uint256 _buyDevFee = 15;
668 
669         uint256 _sellLiquidityFee = 0;
670         uint256 _sellDevFee = 55;
671 
672         uint256 totalSupply = 1 * 1e9 * 1e18;
673 
674         maxTransactionAmount = 1 * 1e7 * 1e18; 
675         maxWallet = 1 * 1e7 * 1e18; 
676         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
677 
678         buyLiquidityFee = _buyLiquidityFee;
679         buyDevFee = _buyDevFee;
680         buyTotalFees = buyLiquidityFee + buyDevFee;
681 
682         sellLiquidityFee = _sellLiquidityFee;
683         sellDevFee = _sellDevFee;
684         sellTotalFees = sellLiquidityFee + sellDevFee;
685 
686         devWallet = address(0x986BBfC7a60e53274477B156422e1Cbaa1F63a1c); // set as dev wallet
687 
688         // exclude from paying fees or having max transaction amount
689         excludeFromFees(owner(), true);
690         excludeFromFees(address(this), true);
691         excludeFromFees(address(0xdead), true);
692 
693         excludeFromMaxTransaction(owner(), true);
694         excludeFromMaxTransaction(address(this), true);
695         excludeFromMaxTransaction(address(0xdead), true);
696 
697         /*
698             _mint is an internal function in ERC20.sol that is only called here,
699             and CANNOT be called ever again
700         */
701         _mint(msg.sender, totalSupply);
702     }
703 
704     receive() external payable {}
705 
706     // once enabled, can never be turned off
707     function enableTrading() external onlyOwner {
708         tradingActive = true;
709         swapEnabled = true;
710     }
711 
712     // remove limits after token is stable
713     function removeLimits() external onlyOwner returns (bool) {
714         limitsInEffect = false;
715         return true;
716     }
717 
718     function updateFees(uint256 _buyLiquidityFee, uint256 _buyDevFee, uint256 _sellLiquidityFee, uint256 _sellDevFee) external onlyOwner {
719         buyLiquidityFee = _buyLiquidityFee;
720         buyDevFee  = _buyDevFee;
721         buyTotalFees = buyLiquidityFee + buyDevFee;
722 
723         sellLiquidityFee = _sellLiquidityFee;
724         sellDevFee = _sellDevFee;
725         sellTotalFees = sellLiquidityFee + sellDevFee;
726     } 
727 
728     // change the minimum amount of tokens to sell from fees
729     function updateSwapTokensAtAmount(uint256 newAmount)
730         external
731         onlyOwner
732         returns (bool)
733     {
734         require(
735             newAmount >= (totalSupply() * 1) / 100000,
736             "Swap amount cannot be lower than 0.001% total supply."
737         );
738         require(
739             newAmount <= (totalSupply() * 5) / 1000,
740             "Swap amount cannot be higher than 0.5% total supply."
741         );
742         swapTokensAtAmount = newAmount;
743         return true;
744     }
745 	
746     function excludeFromMaxTransaction(address updAds, bool isEx)
747         public
748         onlyOwner
749     {
750         _isExcludedMaxTransactionAmount[updAds] = isEx;
751     }
752 
753     // only use to disable contract sales if absolutely necessary (emergency use only)
754     function updateSwapEnabled(bool enabled) external onlyOwner {
755         swapEnabled = enabled;
756     }
757 
758     function excludeFromFees(address account, bool excluded) public onlyOwner {
759         _isExcludedFromFees[account] = excluded;
760         emit ExcludeFromFees(account, excluded);
761     }
762 
763     function setAutomatedMarketMakerPair(address pair, bool value)
764         public
765         onlyOwner
766     {
767         require(
768             pair != uniswapV2Pair,
769             "The pair cannot be removed from automatedMarketMakerPairs"
770         );
771 
772         _setAutomatedMarketMakerPair(pair, value);
773     }
774 
775     function _setAutomatedMarketMakerPair(address pair, bool value) private {
776         automatedMarketMakerPairs[pair] = value;
777 
778         emit SetAutomatedMarketMakerPair(pair, value);
779     }
780 
781     function isExcludedFromFees(address account) public view returns (bool) {
782         return _isExcludedFromFees[account];
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
877                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
878                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
879             }
880             // on buy
881             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
882                 fees = amount.mul(buyTotalFees).div(100);
883                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
884                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
885             }
886 
887             if (fees > 0) {
888                 super._transfer(from, address(this), fees);
889             }
890 
891             amount -= fees;
892         }
893 
894         super._transfer(from, to, amount);
895     }
896 
897     function swapTokensForEth(uint256 tokenAmount) private {
898         // generate the uniswap pair path of token -> weth
899         address[] memory path = new address[](2);
900         path[0] = address(this);
901         path[1] = uniswapV2Router.WETH();
902 
903         _approve(address(this), address(uniswapV2Router), tokenAmount);
904 
905         // make the swap
906         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
907             tokenAmount,
908             0, // accept any amount of ETH
909             path,
910             address(this),
911             block.timestamp
912         );
913     }
914 
915     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
916         // approve token transfer to cover all possible scenarios
917         _approve(address(this), address(uniswapV2Router), tokenAmount);
918 
919         // add the liquidity
920         uniswapV2Router.addLiquidityETH{value: ethAmount}(
921             address(this),
922             tokenAmount,
923             0, // slippage is unavoidable
924             0, // slippage is unavoidable
925             devWallet,
926             block.timestamp
927         );
928     }
929 
930     function swapBack() private {
931         uint256 contractBalance = balanceOf(address(this));
932         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
933         bool success;
934 
935         if (contractBalance == 0 || totalTokensToSwap == 0) {
936             return;
937         }
938 
939         if (contractBalance > swapTokensAtAmount * 20) {
940             contractBalance = swapTokensAtAmount * 20;
941         }
942 
943         // Halve the amount of liquidity tokens
944         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
945         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
946 
947         uint256 initialETHBalance = address(this).balance;
948 
949         swapTokensForEth(amountToSwapForETH);
950 
951         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
952 	
953         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
954 
955         uint256 ethForLiquidity = ethBalance - ethForDev;
956 
957         tokensForLiquidity = 0;
958         tokensForDev = 0;
959 
960         if (liquidityTokens > 0 && ethForLiquidity > 0) {
961             addLiquidity(liquidityTokens, ethForLiquidity);
962             emit SwapAndLiquify(
963                 amountToSwapForETH,
964                 ethForLiquidity,
965                 tokensForLiquidity
966             );
967         }
968 
969         (success, ) = address(devWallet).call{value: address(this).balance}("");
970     }
971 
972 }