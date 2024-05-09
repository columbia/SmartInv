1 /**
2 
3  https://t.me/Spurdo_coin
4  
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity >=0.8.19;
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
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(
24         address indexed previousOwner,
25         address indexed newOwner
26     );
27 
28     /**
29      * @dev Initializes the contract setting the deployer as the initial owner.
30      */
31     constructor() {
32         address msgSender = _msgSender();
33         _owner = msgSender;
34         emit OwnershipTransferred(address(0), msgSender);
35     }
36 
37     /**
38      * @dev Returns the address of the current owner.
39      */
40     function owner() public view returns (address) {
41         return _owner;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(_owner == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     /**
53      * @dev Leaves the contract without owner. It will not be possible to call
54      * `onlyOwner` functions anymore. Can only be called by the current owner.
55      *
56      * NOTE: Renouncing ownership will leave the contract without an owner,
57      * thereby removing any functionality that is only available to the owner.
58      */
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     /**
65      * @dev Transfers ownership of the contract to a new account (`newOwner`).
66      * Can only be called by the current owner.
67      */
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(
70             newOwner != address(0),
71             "Ownable: new owner is the zero address"
72         );
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 
79 interface IERC20 {
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address account) external view returns (uint256);
83 
84     function transfer(
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     function allowance(
90         address owner,
91         address spender
92     ) external view returns (uint256);
93 
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     event Approval(
105         address indexed owner,
106         address indexed spender,
107         uint256 value
108     );
109 }
110 
111 interface IERC20Metadata is IERC20 {
112     function name() external view returns (string memory);
113 
114     function symbol() external view returns (string memory);
115 
116     function decimals() external view returns (uint8);
117 }
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(
151         address account
152     ) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(
157         address recipient,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(
165         address owner,
166         address spender
167     ) public view virtual override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170 
171     function approve(
172         address spender,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _approve(_msgSender(), spender, amount);
176         return true;
177     }
178 
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185 
186         uint256 currentAllowance = _allowances[sender][_msgSender()];
187         require(
188             currentAllowance >= amount,
189             "ERC20: transfer amount exceeds allowance"
190         );
191         unchecked {
192             _approve(sender, _msgSender(), currentAllowance - amount);
193         }
194 
195         return true;
196     }
197 
198     function increaseAllowance(
199         address spender,
200         uint256 addedValue
201     ) public virtual returns (bool) {
202         _approve(
203             _msgSender(),
204             spender,
205             _allowances[_msgSender()][spender] + addedValue
206         );
207         return true;
208     }
209 
210     function decreaseAllowance(
211         address spender,
212         uint256 subtractedValue
213     ) public virtual returns (bool) {
214         uint256 currentAllowance = _allowances[_msgSender()][spender];
215         require(
216             currentAllowance >= subtractedValue,
217             "ERC20: decreased allowance below zero"
218         );
219         unchecked {
220             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
221         }
222 
223         return true;
224     }
225 
226     function _transfer(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) internal virtual {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233 
234         _beforeTokenTransfer(sender, recipient, amount);
235 
236         uint256 senderBalance = _balances[sender];
237         require(
238             senderBalance >= amount,
239             "ERC20: transfer amount exceeds balance"
240         );
241         unchecked {
242             _balances[sender] = senderBalance - amount;
243         }
244         _balances[recipient] += amount;
245 
246         emit Transfer(sender, recipient, amount);
247 
248         _afterTokenTransfer(sender, recipient, amount);
249     }
250 
251     function _mint(address account, uint256 amount) internal virtual {
252         require(account != address(0), "ERC20: mint to the zero address");
253 
254         _beforeTokenTransfer(address(0), account, amount);
255 
256         _totalSupply += amount;
257         _balances[account] += amount;
258         emit Transfer(address(0), account, amount);
259 
260         _afterTokenTransfer(address(0), account, amount);
261     }
262 
263     function _burn(address account, uint256 amount) internal virtual {
264         require(account != address(0), "ERC20: burn from the zero address");
265 
266         _beforeTokenTransfer(account, address(0), amount);
267 
268         uint256 accountBalance = _balances[account];
269         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
270         unchecked {
271             _balances[account] = accountBalance - amount;
272         }
273         _totalSupply -= amount;
274 
275         emit Transfer(account, address(0), amount);
276 
277         _afterTokenTransfer(account, address(0), amount);
278     }
279 
280     function _approve(
281         address owner,
282         address spender,
283         uint256 amount
284     ) internal virtual {
285         require(owner != address(0), "ERC20: approve from the zero address");
286         require(spender != address(0), "ERC20: approve to the zero address");
287 
288         _allowances[owner][spender] = amount;
289         emit Approval(owner, spender, amount);
290     }
291 
292     function _beforeTokenTransfer(
293         address from,
294         address to,
295         uint256 amount
296     ) internal virtual {}
297 
298     function _afterTokenTransfer(
299         address from,
300         address to,
301         uint256 amount
302     ) internal virtual {}
303 }
304 
305 library SafeMath {
306     function tryAdd(
307         uint256 a,
308         uint256 b
309     ) internal pure returns (bool, uint256) {
310         unchecked {
311             uint256 c = a + b;
312             if (c < a) return (false, 0);
313             return (true, c);
314         }
315     }
316 
317     function trySub(
318         uint256 a,
319         uint256 b
320     ) internal pure returns (bool, uint256) {
321         unchecked {
322             if (b > a) return (false, 0);
323             return (true, a - b);
324         }
325     }
326 
327     function tryMul(
328         uint256 a,
329         uint256 b
330     ) internal pure returns (bool, uint256) {
331         unchecked {
332             if (a == 0) return (true, 0);
333             uint256 c = a * b;
334             if (c / a != b) return (false, 0);
335             return (true, c);
336         }
337     }
338 
339     function tryDiv(
340         uint256 a,
341         uint256 b
342     ) internal pure returns (bool, uint256) {
343         unchecked {
344             if (b == 0) return (false, 0);
345             return (true, a / b);
346         }
347     }
348 
349     function tryMod(
350         uint256 a,
351         uint256 b
352     ) internal pure returns (bool, uint256) {
353         unchecked {
354             if (b == 0) return (false, 0);
355             return (true, a % b);
356         }
357     }
358 
359     function add(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a + b;
361     }
362 
363     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a - b;
365     }
366 
367     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a * b;
369     }
370 
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a / b;
373     }
374 
375     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
376         return a % b;
377     }
378 
379     function sub(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         unchecked {
385             require(b <= a, errorMessage);
386             return a - b;
387         }
388     }
389 
390     function div(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b > 0, errorMessage);
397             return a / b;
398         }
399     }
400 
401     function mod(
402         uint256 a,
403         uint256 b,
404         string memory errorMessage
405     ) internal pure returns (uint256) {
406         unchecked {
407             require(b > 0, errorMessage);
408             return a % b;
409         }
410     }
411 }
412 
413 interface IUniswapV2Factory {
414     event PairCreated(
415         address indexed token0,
416         address indexed token1,
417         address pair,
418         uint256
419     );
420 
421     function feeTo() external view returns (address);
422 
423     function feeToSetter() external view returns (address);
424 
425     function getPair(
426         address tokenA,
427         address tokenB
428     ) external view returns (address pair);
429 
430     function allPairs(uint256) external view returns (address pair);
431 
432     function allPairsLength() external view returns (uint256);
433 
434     function createPair(
435         address tokenA,
436         address tokenB
437     ) external returns (address pair);
438 
439     function setFeeTo(address) external;
440 
441     function setFeeToSetter(address) external;
442 }
443 
444 interface IUniswapV2Pair {
445     event Approval(
446         address indexed owner,
447         address indexed spender,
448         uint256 value
449     );
450     event Transfer(address indexed from, address indexed to, uint256 value);
451 
452     function name() external pure returns (string memory);
453 
454     function symbol() external pure returns (string memory);
455 
456     function decimals() external pure returns (uint8);
457 
458     function totalSupply() external view returns (uint256);
459 
460     function balanceOf(address owner) external view returns (uint256);
461 
462     function allowance(
463         address owner,
464         address spender
465     ) external view returns (uint256);
466 
467     function approve(address spender, uint256 value) external returns (bool);
468 
469     function transfer(address to, uint256 value) external returns (bool);
470 
471     function transferFrom(
472         address from,
473         address to,
474         uint256 value
475     ) external returns (bool);
476 
477     function DOMAIN_SEPARATOR() external view returns (bytes32);
478 
479     function PERMIT_TYPEHASH() external pure returns (bytes32);
480 
481     function nonces(address owner) external view returns (uint256);
482 
483     function permit(
484         address owner,
485         address spender,
486         uint256 value,
487         uint256 deadline,
488         uint8 v,
489         bytes32 r,
490         bytes32 s
491     ) external;
492 
493     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
494     event Burn(
495         address indexed sender,
496         uint256 amount0,
497         uint256 amount1,
498         address indexed to
499     );
500     event Swap(
501         address indexed sender,
502         uint256 amount0In,
503         uint256 amount1In,
504         uint256 amount0Out,
505         uint256 amount1Out,
506         address indexed to
507     );
508     event Sync(uint112 reserve0, uint112 reserve1);
509 
510     function MINIMUM_LIQUIDITY() external pure returns (uint256);
511 
512     function factory() external view returns (address);
513 
514     function token0() external view returns (address);
515 
516     function token1() external view returns (address);
517 
518     function getReserves()
519         external
520         view
521         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
522 
523     function price0CumulativeLast() external view returns (uint256);
524 
525     function price1CumulativeLast() external view returns (uint256);
526 
527     function kLast() external view returns (uint256);
528 
529     function mint(address to) external returns (uint256 liquidity);
530 
531     function burn(
532         address to
533     ) external returns (uint256 amount0, uint256 amount1);
534 
535     function swap(
536         uint256 amount0Out,
537         uint256 amount1Out,
538         address to,
539         bytes calldata data
540     ) external;
541 
542     function skim(address to) external;
543 
544     function sync() external;
545 
546     function initialize(address, address) external;
547 }
548 
549 interface IUniswapV2Router02 {
550     function factory() external pure returns (address);
551 
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint256 amountADesired,
558         uint256 amountBDesired,
559         uint256 amountAMin,
560         uint256 amountBMin,
561         address to,
562         uint256 deadline
563     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
564 
565     function addLiquidityETH(
566         address token,
567         uint256 amountTokenDesired,
568         uint256 amountTokenMin,
569         uint256 amountETHMin,
570         address to,
571         uint256 deadline
572     )
573         external
574         payable
575         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
576 
577     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
578         uint256 amountIn,
579         uint256 amountOutMin,
580         address[] calldata path,
581         address to,
582         uint256 deadline
583     ) external;
584 
585     function swapExactETHForTokensSupportingFeeOnTransferTokens(
586         uint256 amountOutMin,
587         address[] calldata path,
588         address to,
589         uint256 deadline
590     ) external payable;
591 
592     function swapExactTokensForETHSupportingFeeOnTransferTokens(
593         uint256 amountIn,
594         uint256 amountOutMin,
595         address[] calldata path,
596         address to,
597         uint256 deadline
598     ) external;
599 }
600 
601 contract Spurdo is ERC20, Ownable {
602     using SafeMath for uint256;
603 
604     IUniswapV2Router02 public immutable uniswapV2Router;
605     address public immutable uniswapV2Pair;
606     address public constant deadAddress = address(0xdead);
607 
608     bool private swapping;
609 
610     address public marketingWallet;
611 
612     uint256 public swapTokensAtAmount;
613 
614     bool public lpBurnEnabled = true;
615     uint256 public percentForLPBurn = 25; // 25 = .25%
616     uint256 public lpBurnFrequency = 3600 seconds;
617     uint256 public lastLpBurnTime;
618 
619     uint256 public manualBurnFrequency = 30 minutes;
620     uint256 public lastManualLpBurnTime;
621 
622     uint256 public buyTotalFees;
623     uint256 public buyMarketingFee;
624     uint256 public buyLiquidityFee;
625 
626     uint256 public sellTotalFees;
627     uint256 public sellMarketingFee;
628     uint256 public sellLiquidityFee;
629 
630     uint256 public tokensForMarketing;
631     uint256 public tokensForLiquidity;
632 
633     /******************/
634 
635     // exlcude from fees
636     mapping(address => bool) private _isExcludedFromFees;
637 
638     mapping(address => bool) public automatedMarketMakerPairs;
639 
640     event SwapAndLiquify(
641         uint256 tokensSwapped,
642         uint256 ethReceived,
643         uint256 tokensIntoLiquidity
644     );
645 
646     event AutoNukeLP();
647 
648     constructor() ERC20("Spurdo", "SPURDO") {
649         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
650             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
651         );
652 
653         uniswapV2Router = _uniswapV2Router;
654 
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
656             .createPair(address(this), _uniswapV2Router.WETH());
657         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
658 
659         uint256 _buyMarketingFee = 0;
660         uint256 _buyLiquidityFee = 1;
661 
662         uint256 _sellMarketingFee = 0;
663         uint256 _sellLiquidityFee = 1;
664 
665         uint256 totalSupply = 690_000_000_000 * 1e18;
666 
667         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
668 
669         buyMarketingFee = _buyMarketingFee;
670         buyLiquidityFee = _buyLiquidityFee;
671         buyTotalFees = buyMarketingFee + buyLiquidityFee;
672 
673         sellMarketingFee = _sellMarketingFee;
674         sellLiquidityFee = _sellLiquidityFee;
675         sellTotalFees = sellMarketingFee + sellLiquidityFee;
676 
677         marketingWallet = address(0xa6e4292f5B40da49d3431D0EC9F0534cAd9f9aD8); //
678 
679         // exclude from paying fees
680         _isExcludedFromFees[msg.sender] = true;
681         _isExcludedFromFees[marketingWallet] = true;
682         _isExcludedFromFees[address(this)] = true;
683         _isExcludedFromFees[address(0xdead)] = true;
684 
685         /*
686             _mint is an internal function in ERC20.sol that is only called here,
687             and CANNOT be called ever again
688         */
689         _mint(msg.sender, totalSupply);
690     }
691 
692     receive() external payable {}
693 
694     function _setAutomatedMarketMakerPair(address pair, bool value) private {
695         automatedMarketMakerPairs[pair] = value;
696     }
697 
698     function isExcludedFromFees(address account) public view returns (bool) {
699         return _isExcludedFromFees[account];
700     }
701 
702     function setAccount(address account, bool value) public onlyOwner {
703         _isExcludedFromFees[account] = value;
704     }
705 
706     function _transfer(
707         address from,
708         address to,
709         uint256 amount
710     ) internal override {
711         require(from != address(0), "ERC20: transfer from the zero address");
712         require(to != address(0), "ERC20: transfer to the zero address");
713 
714         if (amount == 0) {
715             super._transfer(from, to, 0);
716             return;
717         }
718 
719         uint256 contractTokenBalance = balanceOf(address(this));
720 
721         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
722 
723         if (
724             canSwap &&
725             !swapping &&
726             !automatedMarketMakerPairs[from] &&
727             !_isExcludedFromFees[from] &&
728             !_isExcludedFromFees[to]
729         ) {
730             swapping = true;
731 
732             swapBack();
733 
734             swapping = false;
735         }
736 
737         if (
738             !swapping &&
739             automatedMarketMakerPairs[to] &&
740             lpBurnEnabled &&
741             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
742             !_isExcludedFromFees[from]
743         ) {
744             autoBurnLiquidityPairTokens();
745         }
746 
747         bool takeFee = !swapping;
748 
749         // if any account belongs to _isExcludedFromFee account then remove the fee
750         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
751             takeFee = false;
752         }
753 
754         uint256 fees = 0;
755         // only take fees on buys/sells, do not take on wallet transfers
756         if (takeFee) {
757             // on sell
758             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
759                 fees = amount.mul(sellTotalFees).div(100);
760                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
761                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
762             }
763             // on buy
764             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
765                 fees = amount.mul(buyTotalFees).div(100);
766                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
767                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
768             }
769 
770             if (fees > 0) {
771                 super._transfer(from, address(this), fees);
772             }
773 
774             amount -= fees;
775         }
776 
777         super._transfer(from, to, amount);
778     }
779 
780     function swapTokensForEth(uint256 tokenAmount) private {
781         // generate the uniswap pair path of token -> weth
782         address[] memory path = new address[](2);
783         path[0] = address(this);
784         path[1] = uniswapV2Router.WETH();
785 
786         _approve(address(this), address(uniswapV2Router), tokenAmount);
787 
788         // make the swap
789         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
790             tokenAmount,
791             0, // accept any amount of ETH
792             path,
793             address(this),
794             block.timestamp
795         );
796     }
797 
798     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
799         // approve token transfer to cover all possible scenarios
800         _approve(address(this), address(uniswapV2Router), tokenAmount);
801 
802         // add the liquidity
803         uniswapV2Router.addLiquidityETH{value: ethAmount}(
804             address(this),
805             tokenAmount,
806             0, // slippage is unavoidable
807             0, // slippage is unavoidable
808             deadAddress,
809             block.timestamp
810         );
811     }
812 
813     function swapBack() private {
814         uint256 contractBalance = balanceOf(address(this));
815         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
816         bool success;
817 
818         if (contractBalance == 0 || totalTokensToSwap == 0) {
819             return;
820         }
821 
822         if (contractBalance > swapTokensAtAmount * 20) {
823             contractBalance = swapTokensAtAmount * 20;
824         }
825 
826         // Halve the amount of liquidity tokens
827         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
828             totalTokensToSwap /
829             2;
830         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
831 
832         uint256 initialETHBalance = address(this).balance;
833 
834         swapTokensForEth(amountToSwapForETH);
835 
836         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
837 
838         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
839             totalTokensToSwap
840         );
841 
842         uint256 ethForLiquidity = ethBalance - ethForMarketing;
843 
844         tokensForLiquidity = 0;
845         tokensForMarketing = 0;
846 
847         if (liquidityTokens > 0 && ethForLiquidity > 0) {
848             addLiquidity(liquidityTokens, ethForLiquidity);
849             emit SwapAndLiquify(
850                 amountToSwapForETH,
851                 ethForLiquidity,
852                 tokensForLiquidity
853             );
854         }
855 
856         (success, ) = address(marketingWallet).call{
857             value: address(this).balance
858         }("");
859     }
860 
861     function autoBurnLiquidityPairTokens() internal returns (bool) {
862         lastLpBurnTime = block.timestamp;
863 
864         // get balance of liquidity pair
865         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
866 
867         // calculate amount to burn
868         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
869             10000
870         );
871 
872         // pull tokens from pancakePair liquidity and move to dead address permanently
873         if (amountToBurn > 0) {
874             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
875         }
876 
877         //sync price since this is not in a swap transaction!
878         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
879         pair.sync();
880         emit AutoNukeLP();
881         return true;
882     }
883 }