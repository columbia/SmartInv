1 /**
2 
3 */
4 // Telegram: https://t.me/ginoeth
5 // Medium: https://medium.com/@ginoeth/boiled-chicken-carrots-and-rice-60d645bf72f0
6 // Twitter: https://twitter.com/ginoerc
7 // Website: ginoerc.com
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
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
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41 
42     function renounceOwnership() public virtual onlyOwner {
43         _transferOwnership(address(0));
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         _transferOwnership(newOwner);
49     }
50 
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
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IERC20Metadata is IERC20 {
91 
92     function name() external view returns (string memory);
93 
94     function symbol() external view returns (string memory);
95 
96     function decimals() external view returns (uint8);
97 }
98 
99 
100 contract ERC20 is Context, IERC20, IERC20Metadata {
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
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
565 contract Gino is ERC20, Ownable {
566     using SafeMath for uint256;
567 
568     IUniswapV2Router02 public immutable uniswapV2Router;
569     address public immutable uniswapV2Pair;
570     address public constant deadAddress = address(0xdead);
571 
572     bool private swapping;
573 
574     address public marketingWallet;
575     address public devWallet;
576 
577     uint256 public maxTransactionAmount;
578     uint256 public swapTokensAtAmount;
579     uint256 public maxWallet;
580 
581     uint256 public percentForLPBurn = 0; 
582     bool public lpBurnEnabled = false;
583     uint256 public lpBurnFrequency = 3600 seconds;
584     uint256 public lastLpBurnTime;
585 
586     uint256 public manualBurnFrequency = 30 minutes;
587     uint256 public lastManualLpBurnTime;
588 
589     bool public limitsInEffect = true;
590     bool public tradingActive = false;
591     bool public swapEnabled = true;
592 
593     mapping(address => uint256) private _holderLastTransferTimestamp; 
594     bool public transferDelayEnabled = true;
595 
596     uint256 public buyTotalFees;
597     uint256 public buyMarketingFee;
598     uint256 public buyLiquidityFee;
599     uint256 public buyDevFee;
600 
601     uint256 public sellTotalFees;
602     uint256 public sellMarketingFee;
603     uint256 public sellLiquidityFee;
604     uint256 public sellDevFee;
605 
606     uint256 public tokensForMarketing;
607     uint256 public tokensForLiquidity;
608     uint256 public tokensForDev;
609 
610     mapping(address => bool) private _isExcludedFromFees;
611     mapping(address => bool) public _isExcludedMaxTransactionAmount;
612 
613     mapping(address => bool) public automatedMarketMakerPairs;
614 
615     event UpdateUniswapV2Router(
616         address indexed newAddress,
617         address indexed oldAddress
618     );
619 
620     event ExcludeFromFees(address indexed account, bool isExcluded);
621 
622     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
623 
624     event marketingWalletUpdated(
625         address indexed newWallet,
626         address indexed oldWallet
627     );
628 
629     event devWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633 
634     event SwapAndLiquify(
635         uint256 tokensSwapped,
636         uint256 ethReceived,
637         uint256 tokensIntoLiquidity
638     );
639 
640     event AutoNukeLP();
641 
642     event ManualNukeLP();
643 
644     constructor() ERC20("GINO", "GINO") {
645         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
646             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
647         );
648 
649         excludeFromMaxTransaction(address(_uniswapV2Router), true);
650         uniswapV2Router = _uniswapV2Router;
651 
652         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
653             .createPair(address(this), _uniswapV2Router.WETH());
654         excludeFromMaxTransaction(address(uniswapV2Pair), true);
655         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
656 
657         uint256 _buyMarketingFee = 10;
658         uint256 _buyLiquidityFee = 0;
659         uint256 _buyDevFee = 10;
660 
661         uint256 _sellMarketingFee = 10;
662         uint256 _sellLiquidityFee = 0;
663         uint256 _sellDevFee = 10;
664 
665         uint256 totalSupply = 1_000_000_000 * 1e18;
666 
667         maxTransactionAmount = 15_000_000 * 1e18; 
668         maxWallet = 20_000_000 * 1e18; 
669         swapTokensAtAmount = (totalSupply * 5) / 10000;
670 
671         buyMarketingFee = _buyMarketingFee;
672         buyLiquidityFee = _buyLiquidityFee;
673         buyDevFee = _buyDevFee;
674         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
675 
676         sellMarketingFee = _sellMarketingFee;
677         sellLiquidityFee = _sellLiquidityFee;
678         sellDevFee = _sellDevFee;
679         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
680 
681         marketingWallet = address(0x0750AF6A19EB5AD16ac683543645722a0d153EC5); 
682         devWallet = address(0xa5d61dF095A2bB263796757A87e731852C41e3Ee); 
683 
684         // exclude from paying fees or having max transaction amount
685         excludeFromFees(owner(), true);
686         excludeFromFees(address(this), true);
687         excludeFromFees(address(0xdead), true);
688 
689         excludeFromMaxTransaction(owner(), true);
690         excludeFromMaxTransaction(address(this), true);
691         excludeFromMaxTransaction(address(0xdead), true);
692 
693         _mint(msg.sender, totalSupply);
694     }
695 
696     receive() external payable {}
697 
698     function enableTrading() external onlyOwner {
699         tradingActive = true;
700         swapEnabled = true;
701         lastLpBurnTime = block.timestamp;
702     }
703 
704     function removeLimits() external onlyOwner returns (bool) {
705         limitsInEffect = false;
706         return true;
707     }
708 
709     function disableTransferDelay() external onlyOwner returns (bool) {
710         transferDelayEnabled = false;
711         return true;
712     }
713 
714     function updateSwapTokensAtAmount(uint256 newAmount)
715         external
716         onlyOwner
717         returns (bool)
718     {
719         require(
720             newAmount >= (totalSupply() * 1) / 100000,
721             "Swap amount cannot be lower than 0.001% total supply."
722         );
723         require(
724             newAmount <= (totalSupply() * 5) / 1000,
725             "Swap amount cannot be higher than 0.5% total supply."
726         );
727         swapTokensAtAmount = newAmount;
728         return true;
729     }
730 
731     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
732         require(
733             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
734             "Cannot set maxTransactionAmount lower than 0.1%"
735         );
736         maxTransactionAmount = newNum * (10**18);
737     }
738 
739     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
740         require(
741             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
742             "Cannot set maxWallet lower than 0.5%"
743         );
744         maxWallet = newNum * (10**18);
745     }
746 
747     function excludeFromMaxTransaction(address updAds, bool isEx)
748         public
749         onlyOwner
750     {
751         _isExcludedMaxTransactionAmount[updAds] = isEx;
752     }
753 
754     function updateSwapEnabled(bool enabled) external onlyOwner {
755         swapEnabled = enabled;
756     }
757 
758     function updateBuyFees(
759         uint256 _marketingFee,
760         uint256 _liquidityFee,
761         uint256 _devFee
762     ) external onlyOwner {
763         buyMarketingFee = _marketingFee;
764         buyLiquidityFee = _liquidityFee;
765         buyDevFee = _devFee;
766         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
767         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
768     }
769 
770     function updateSellFees(
771         uint256 _marketingFee,
772         uint256 _liquidityFee,
773         uint256 _devFee
774     ) external onlyOwner {
775         sellMarketingFee = _marketingFee;
776         sellLiquidityFee = _liquidityFee;
777         sellDevFee = _devFee;
778         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
779         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
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
805     function updateMarketingWallet(address newMarketingWallet)
806         external
807         onlyOwner
808     {
809         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
810         marketingWallet = newMarketingWallet;
811     }
812 
813     function updateDevWallet(address newWallet) external onlyOwner {
814         emit devWalletUpdated(newWallet, devWallet);
815         devWallet = newWallet;
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
943                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
944                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
945             }
946             // on buy
947             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
948                 fees = amount.mul(buyTotalFees).div(100);
949                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
950                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
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
1035         (success, ) = address(devWallet).call{value: ethForDev}("");
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