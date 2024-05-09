1 /**
2 
3 https://t.me/thaterc20
4 
5 */
6 
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _transferOwnership(newOwner);
48     }
49 
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64 
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72 
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
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
110     constructor(string memory name_, string memory symbol_) {
111         _name = name_;
112         _symbol = symbol_;
113     }
114 
115 
116     function name() public view virtual override returns (string memory) {
117         return _name;
118     }
119 
120 
121     function symbol() public view virtual override returns (string memory) {
122         return _symbol;
123     }
124 
125 
126     function decimals() public view virtual override returns (uint8) {
127         return 18;
128     }
129 
130 
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view virtual override returns (uint256) {
136         return _balances[account];
137     }
138 
139     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
140         _transfer(_msgSender(), recipient, amount);
141         return true;
142     }
143 
144 
145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
146         return _allowances[owner][spender];
147     }
148 
149     function approve(address spender, uint256 amount) public virtual override returns (bool) {
150         _approve(_msgSender(), spender, amount);
151         return true;
152     }
153 
154     function transferFrom(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) public virtual override returns (bool) {
159         _transfer(sender, recipient, amount);
160 
161         uint256 currentAllowance = _allowances[sender][_msgSender()];
162         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
163         unchecked {
164             _approve(sender, _msgSender(), currentAllowance - amount);
165         }
166 
167         return true;
168     }
169 
170     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
171         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
172         return true;
173     }
174 
175     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
176         uint256 currentAllowance = _allowances[_msgSender()][spender];
177         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
178         unchecked {
179             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
180         }
181 
182         return true;
183     }
184 
185     function _transfer(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) internal virtual {
190         require(sender != address(0), "ERC20: transfer from the zero address");
191         require(recipient != address(0), "ERC20: transfer to the zero address");
192 
193         _beforeTokenTransfer(sender, recipient, amount);
194 
195         uint256 senderBalance = _balances[sender];
196         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
197         unchecked {
198             _balances[sender] = senderBalance - amount;
199         }
200         _balances[recipient] += amount;
201 
202         emit Transfer(sender, recipient, amount);
203 
204         _afterTokenTransfer(sender, recipient, amount);
205     }
206 
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209 
210         _beforeTokenTransfer(address(0), account, amount);
211 
212         _totalSupply += amount;
213         _balances[account] += amount;
214         emit Transfer(address(0), account, amount);
215 
216         _afterTokenTransfer(address(0), account, amount);
217     }
218 
219     function _burn(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: burn from the zero address");
221 
222         _beforeTokenTransfer(account, address(0), amount);
223 
224         uint256 accountBalance = _balances[account];
225         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
226         unchecked {
227             _balances[account] = accountBalance - amount;
228         }
229         _totalSupply -= amount;
230 
231         emit Transfer(account, address(0), amount);
232 
233         _afterTokenTransfer(account, address(0), amount);
234     }
235 
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _beforeTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 
254     function _afterTokenTransfer(
255         address from,
256         address to,
257         uint256 amount
258     ) internal virtual {}
259 }
260 
261 
262 library SafeMath {
263 
264     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             uint256 c = a + b;
267             if (c < a) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b > a) return (false, 0);
275             return (true, a - b);
276         }
277     }
278 
279 
280     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
283             // benefit is lost if 'b' is also tested.
284             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
567 contract THAT is ERC20, Ownable {
568     using SafeMath for uint256;
569 
570     IUniswapV2Router02 public immutable uniswapV2Router;
571     address public immutable uniswapV2Pair;
572     address public constant deadAddress = address(0xdead);
573 
574     bool private swapping;
575 
576     address public marketingWallet;
577     address public devWallet;
578 
579     uint256 public maxTransactionAmount;
580     uint256 public swapTokensAtAmount;
581     uint256 public maxWallet;
582 
583     uint256 public percentForLPBurn = 0; // 25 = .25%
584     bool public lpBurnEnabled = false;
585     uint256 public lpBurnFrequency = 3600 seconds;
586     uint256 public lastLpBurnTime;
587 
588     uint256 public manualBurnFrequency = 30 minutes;
589     uint256 public lastManualLpBurnTime;
590 
591     bool public limitsInEffect = true;
592     bool public tradingActive = false;
593     bool public swapEnabled = true;
594 
595     // Anti-bot and anti-whale mappings and variables
596     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
597     bool public transferDelayEnabled = true;
598 
599     uint256 public buyTotalFees;
600     uint256 public buyMarketingFee;
601     uint256 public buyLiquidityFee;
602     uint256 public buyDevFee;
603 
604     uint256 public sellTotalFees;
605     uint256 public sellMarketingFee;
606     uint256 public sellLiquidityFee;
607     uint256 public sellDevFee;
608 
609     uint256 public tokensForMarketing;
610     uint256 public tokensForLiquidity;
611     uint256 public tokensForDev;
612 
613     /******************/
614 
615     // exlcude from fees and max transaction amount
616     mapping(address => bool) private _isExcludedFromFees;
617     mapping(address => bool) public _isExcludedMaxTransactionAmount;
618 
619     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
620     // could be subject to a maximum transfer amount
621     mapping(address => bool) public automatedMarketMakerPairs;
622 
623     event UpdateUniswapV2Router(
624         address indexed newAddress,
625         address indexed oldAddress
626     );
627 
628     event ExcludeFromFees(address indexed account, bool isExcluded);
629 
630     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
631 
632     event marketingWalletUpdated(
633         address indexed newWallet,
634         address indexed oldWallet
635     );
636 
637     event devWalletUpdated(
638         address indexed newWallet,
639         address indexed oldWallet
640     );
641 
642     event SwapAndLiquify(
643         uint256 tokensSwapped,
644         uint256 ethReceived,
645         uint256 tokensIntoLiquidity
646     );
647 
648     event AutoNukeLP();
649 
650     event ManualNukeLP();
651 
652     constructor() ERC20("THAT", "THAT") {
653         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
654             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
655         );
656 
657         excludeFromMaxTransaction(address(_uniswapV2Router), true);
658         uniswapV2Router = _uniswapV2Router;
659 
660         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
661             .createPair(address(this), _uniswapV2Router.WETH());
662         excludeFromMaxTransaction(address(uniswapV2Pair), true);
663         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
664 
665         uint256 _buyMarketingFee = 12;
666         uint256 _buyLiquidityFee = 0;
667         uint256 _buyDevFee = 10;
668 
669         uint256 _sellMarketingFee = 12;
670         uint256 _sellLiquidityFee = 0;
671         uint256 _sellDevFee = 12;
672 
673         uint256 totalSupply = 1_000_000_000 * 1e18;
674 
675         maxTransactionAmount = 10_000_000 * 1e18; 
676         maxWallet = 20_000_000 * 1e18; 
677         swapTokensAtAmount = (totalSupply * 5) / 10000;
678 
679         buyMarketingFee = _buyMarketingFee;
680         buyLiquidityFee = _buyLiquidityFee;
681         buyDevFee = _buyDevFee;
682         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
683 
684         sellMarketingFee = _sellMarketingFee;
685         sellLiquidityFee = _sellLiquidityFee;
686         sellDevFee = _sellDevFee;
687         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
688 
689         marketingWallet = address(0xE81F9149bfbb62B1B9d84ccA26F0399e392Cae2e); 
690         devWallet = address(0xE81F9149bfbb62B1B9d84ccA26F0399e392Cae2e); 
691 
692         // exclude from paying fees or having max transaction amount
693         excludeFromFees(owner(), true);
694         excludeFromFees(address(this), true);
695         excludeFromFees(address(0xdead), true);
696 
697         excludeFromMaxTransaction(owner(), true);
698         excludeFromMaxTransaction(address(this), true);
699         excludeFromMaxTransaction(address(0xdead), true);
700 
701         _mint(msg.sender, totalSupply);
702     }
703 
704     receive() external payable {}
705 
706     function enableTrading() external onlyOwner {
707         tradingActive = true;
708         swapEnabled = true;
709         lastLpBurnTime = block.timestamp;
710     }
711 
712     function removeLimits() external onlyOwner returns (bool) {
713         limitsInEffect = false;
714         return true;
715     }
716 
717     function disableTransferDelay() external onlyOwner returns (bool) {
718         transferDelayEnabled = false;
719         return true;
720     }
721 
722     function updateSwapTokensAtAmount(uint256 newAmount)
723         external
724         onlyOwner
725         returns (bool)
726     {
727         require(
728             newAmount >= (totalSupply() * 1) / 100000,
729             "Swap amount cannot be lower than 0.001% total supply."
730         );
731         require(
732             newAmount <= (totalSupply() * 5) / 1000,
733             "Swap amount cannot be higher than 0.5% total supply."
734         );
735         swapTokensAtAmount = newAmount;
736         return true;
737     }
738 
739     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
740         require(
741             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
742             "Cannot set maxTransactionAmount lower than 0.1%"
743         );
744         maxTransactionAmount = newNum * (10**18);
745     }
746 
747     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
748         require(
749             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
750             "Cannot set maxWallet lower than 0.5%"
751         );
752         maxWallet = newNum * (10**18);
753     }
754 
755     function excludeFromMaxTransaction(address updAds, bool isEx)
756         public
757         onlyOwner
758     {
759         _isExcludedMaxTransactionAmount[updAds] = isEx;
760     }
761 
762     function updateSwapEnabled(bool enabled) external onlyOwner {
763         swapEnabled = enabled;
764     }
765 
766     function updateBuyFees(
767         uint256 _marketingFee,
768         uint256 _liquidityFee,
769         uint256 _devFee
770     ) external onlyOwner {
771         buyMarketingFee = _marketingFee;
772         buyLiquidityFee = _liquidityFee;
773         buyDevFee = _devFee;
774         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
775         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
776     }
777 
778     function updateSellFees(
779         uint256 _marketingFee,
780         uint256 _liquidityFee,
781         uint256 _devFee
782     ) external onlyOwner {
783         sellMarketingFee = _marketingFee;
784         sellLiquidityFee = _liquidityFee;
785         sellDevFee = _devFee;
786         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
787         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
788     }
789 
790     function excludeFromFees(address account, bool excluded) public onlyOwner {
791         _isExcludedFromFees[account] = excluded;
792         emit ExcludeFromFees(account, excluded);
793     }
794 
795     function setAutomatedMarketMakerPair(address pair, bool value)
796         public
797         onlyOwner
798     {
799         require(
800             pair != uniswapV2Pair,
801             "The pair cannot be removed from automatedMarketMakerPairs"
802         );
803 
804         _setAutomatedMarketMakerPair(pair, value);
805     }
806 
807     function _setAutomatedMarketMakerPair(address pair, bool value) private {
808         automatedMarketMakerPairs[pair] = value;
809 
810         emit SetAutomatedMarketMakerPair(pair, value);
811     }
812 
813     function updateMarketingWallet(address newMarketingWallet)
814         external
815         onlyOwner
816     {
817         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
818         marketingWallet = newMarketingWallet;
819     }
820 
821     function updateDevWallet(address newWallet) external onlyOwner {
822         emit devWalletUpdated(newWallet, devWallet);
823         devWallet = newWallet;
824     }
825 
826     function isExcludedFromFees(address account) public view returns (bool) {
827         return _isExcludedFromFees[account];
828     }
829 
830     event BoughtEarly(address indexed sniper);
831 
832     function _transfer(
833         address from,
834         address to,
835         uint256 amount
836     ) internal override {
837         require(from != address(0), "ERC20: transfer from the zero address");
838         require(to != address(0), "ERC20: transfer to the zero address");
839 
840         if (amount == 0) {
841             super._transfer(from, to, 0);
842             return;
843         }
844 
845         if (limitsInEffect) {
846             if (
847                 from != owner() &&
848                 to != owner() &&
849                 to != address(0) &&
850                 to != address(0xdead) &&
851                 !swapping
852             ) {
853                 if (!tradingActive) {
854                     require(
855                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
856                         "Trading is not active."
857                     );
858                 }
859 
860                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
861                 if (transferDelayEnabled) {
862                     if (
863                         to != owner() &&
864                         to != address(uniswapV2Router) &&
865                         to != address(uniswapV2Pair)
866                     ) {
867                         require(
868                             _holderLastTransferTimestamp[tx.origin] <
869                                 block.number,
870                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
871                         );
872                         _holderLastTransferTimestamp[tx.origin] = block.number;
873                     }
874                 }
875 
876                 //when buy
877                 if (
878                     automatedMarketMakerPairs[from] &&
879                     !_isExcludedMaxTransactionAmount[to]
880                 ) {
881                     require(
882                         amount <= maxTransactionAmount,
883                         "Buy transfer amount exceeds the maxTransactionAmount."
884                     );
885                     require(
886                         amount + balanceOf(to) <= maxWallet,
887                         "Max wallet exceeded"
888                     );
889                 }
890                 //when sell
891                 else if (
892                     automatedMarketMakerPairs[to] &&
893                     !_isExcludedMaxTransactionAmount[from]
894                 ) {
895                     require(
896                         amount <= maxTransactionAmount,
897                         "Sell transfer amount exceeds the maxTransactionAmount."
898                     );
899                 } else if (!_isExcludedMaxTransactionAmount[to]) {
900                     require(
901                         amount + balanceOf(to) <= maxWallet,
902                         "Max wallet exceeded"
903                     );
904                 }
905             }
906         }
907 
908         uint256 contractTokenBalance = balanceOf(address(this));
909 
910         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
911 
912         if (
913             canSwap &&
914             swapEnabled &&
915             !swapping &&
916             !automatedMarketMakerPairs[from] &&
917             !_isExcludedFromFees[from] &&
918             !_isExcludedFromFees[to]
919         ) {
920             swapping = true;
921 
922             swapBack();
923 
924             swapping = false;
925         }
926 
927         if (
928             !swapping &&
929             automatedMarketMakerPairs[to] &&
930             lpBurnEnabled &&
931             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
932             !_isExcludedFromFees[from]
933         ) {
934             autoBurnLiquidityPairTokens();
935         }
936 
937         bool takeFee = !swapping;
938 
939         // if any account belongs to _isExcludedFromFee account then remove the fee
940         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
941             takeFee = false;
942         }
943 
944         uint256 fees = 0;
945         // only take fees on buys/sells, do not take on wallet transfers
946         if (takeFee) {
947             // on sell
948             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
949                 fees = amount.mul(sellTotalFees).div(100);
950                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
951                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
952                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
953             }
954             // on buy
955             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
956                 fees = amount.mul(buyTotalFees).div(100);
957                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
958                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
959                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
960             }
961 
962             if (fees > 0) {
963                 super._transfer(from, address(this), fees);
964             }
965 
966             amount -= fees;
967         }
968 
969         super._transfer(from, to, amount);
970     }
971 
972     function swapTokensForEth(uint256 tokenAmount) private {
973         // generate the uniswap pair path of token -> weth
974         address[] memory path = new address[](2);
975         path[0] = address(this);
976         path[1] = uniswapV2Router.WETH();
977 
978         _approve(address(this), address(uniswapV2Router), tokenAmount);
979 
980         // make the swap
981         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
982             tokenAmount,
983             0, // accept any amount of ETH
984             path,
985             address(this),
986             block.timestamp
987         );
988     }
989 
990     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
991         // approve token transfer to cover all possible scenarios
992         _approve(address(this), address(uniswapV2Router), tokenAmount);
993 
994         // add the liquidity
995         uniswapV2Router.addLiquidityETH{value: ethAmount}(
996             address(this),
997             tokenAmount,
998             0, // slippage is unavoidable
999             0, // slippage is unavoidable
1000             deadAddress,
1001             block.timestamp
1002         );
1003     }
1004 
1005     function swapBack() private {
1006         uint256 contractBalance = balanceOf(address(this));
1007         uint256 totalTokensToSwap = tokensForLiquidity +
1008             tokensForMarketing +
1009             tokensForDev;
1010         bool success;
1011 
1012         if (contractBalance == 0 || totalTokensToSwap == 0) {
1013             return;
1014         }
1015 
1016         if (contractBalance > swapTokensAtAmount * 20) {
1017             contractBalance = swapTokensAtAmount * 20;
1018         }
1019 
1020         // Halve the amount of liquidity tokens
1021         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1022             totalTokensToSwap /
1023             2;
1024         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1025 
1026         uint256 initialETHBalance = address(this).balance;
1027 
1028         swapTokensForEth(amountToSwapForETH);
1029 
1030         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1031 
1032         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1033             totalTokensToSwap
1034         );
1035         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1036 
1037         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1038 
1039         tokensForLiquidity = 0;
1040         tokensForMarketing = 0;
1041         tokensForDev = 0;
1042 
1043         (success, ) = address(devWallet).call{value: ethForDev}("");
1044 
1045         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1046             addLiquidity(liquidityTokens, ethForLiquidity);
1047             emit SwapAndLiquify(
1048                 amountToSwapForETH,
1049                 ethForLiquidity,
1050                 tokensForLiquidity
1051             );
1052         }
1053 
1054         (success, ) = address(marketingWallet).call{
1055             value: address(this).balance
1056         }("");
1057     }
1058 
1059     function setAutoLPBurnSettings(
1060         uint256 _frequencyInSeconds,
1061         uint256 _percent,
1062         bool _Enabled
1063     ) external onlyOwner {
1064         require(
1065             _frequencyInSeconds >= 600,
1066             "cannot set buyback more often than every 10 minutes"
1067         );
1068         require(
1069             _percent <= 1000 && _percent >= 0,
1070             "Must set auto LP burn percent between 0% and 10%"
1071         );
1072         lpBurnFrequency = _frequencyInSeconds;
1073         percentForLPBurn = _percent;
1074         lpBurnEnabled = _Enabled;
1075     }
1076 
1077     function autoBurnLiquidityPairTokens() internal returns (bool) {
1078         lastLpBurnTime = block.timestamp;
1079 
1080         // get balance of liquidity pair
1081         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1082 
1083         // calculate amount to burn
1084         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1085             10000
1086         );
1087 
1088         // pull tokens from pancakePair liquidity and move to dead address permanently
1089         if (amountToBurn > 0) {
1090             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1091         }
1092 
1093         //sync price since this is not in a swap transaction!
1094         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1095         pair.sync();
1096         emit AutoNukeLP();
1097         return true;
1098     }
1099 
1100     function manualBurnLiquidityPairTokens(uint256 percent)
1101         external
1102         onlyOwner
1103         returns (bool)
1104     {
1105         require(
1106             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1107             "Must wait for cooldown to finish"
1108         );
1109         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1110         lastManualLpBurnTime = block.timestamp;
1111 
1112         // get balance of liquidity pair
1113         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1114 
1115         // calculate amount to burn
1116         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1117 
1118         // pull tokens from pancakePair liquidity and move to dead address permanently
1119         if (amountToBurn > 0) {
1120             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1121         }
1122 
1123         //sync price since this is not in a swap transaction!
1124         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1125         pair.sync();
1126         emit ManualNukeLP();
1127         return true;
1128     }
1129 }