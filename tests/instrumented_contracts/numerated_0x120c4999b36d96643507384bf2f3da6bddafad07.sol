1 // SPDX-License-Identifier: MIT
2 
3 /** 
4      ⚡ SnapTrade
5 
6      DEX Trading made fast & easy.
7      Through our Telegram Dapp, you 
8      can perform DEX swaps with 100%
9      slippage in a fast and reliable
10      manner.
11 
12      snaptrade.xyz
13      t.me/SnapTradeERC
14 */
15 
16 pragma solidity 0.8.13;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this;
25         return msg.data;
26     }
27 }
28 
29 interface IUniswapV2Pair {
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     function name() external pure returns (string memory);
38 
39     function symbol() external pure returns (string memory);
40 
41     function decimals() external pure returns (uint8);
42 
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address owner) external view returns (uint256);
46 
47     function allowance(address owner, address spender)
48         external
49         view
50         returns (uint256);
51 
52     function approve(address spender, uint256 value) external returns (bool);
53 
54     function transfer(address to, uint256 value) external returns (bool);
55 
56     function transferFrom(
57         address from,
58         address to,
59         uint256 value
60     ) external returns (bool);
61 
62     function DOMAIN_SEPARATOR() external view returns (bytes32);
63 
64     function PERMIT_TYPEHASH() external pure returns (bytes32);
65 
66     function nonces(address owner) external view returns (uint256);
67 
68     function permit(
69         address owner,
70         address spender,
71         uint256 value,
72         uint256 deadline,
73         uint8 v,
74         bytes32 r,
75         bytes32 s
76     ) external;
77 
78     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
79     event Swap(
80         address indexed sender,
81         uint256 amount0In,
82         uint256 amount1In,
83         uint256 amount0Out,
84         uint256 amount1Out,
85         address indexed to
86     );
87     event Sync(uint112 reserve0, uint112 reserve1);
88 
89     function MINIMUM_LIQUIDITY() external pure returns (uint256);
90 
91     function factory() external view returns (address);
92 
93     function token0() external view returns (address);
94 
95     function token1() external view returns (address);
96 
97     function getReserves()
98         external
99         view
100         returns (
101             uint112 reserve0,
102             uint112 reserve1,
103             uint32 blockTimestampLast
104         );
105 
106     function price0CumulativeLast() external view returns (uint256);
107 
108     function price1CumulativeLast() external view returns (uint256);
109 
110     function kLast() external view returns (uint256);
111 
112     function mint(address to) external returns (uint256 liquidity);
113 
114     function burn(address to)
115         external
116         returns (uint256 amount0, uint256 amount1);
117 
118     function swap(
119         uint256 amount0Out,
120         uint256 amount1Out,
121         address to,
122         bytes calldata data
123     ) external;
124 
125     function skim(address to) external;
126 
127     function sync() external;
128 
129     function initialize(address, address) external;
130 }
131 
132 interface IUniswapV2Factory {
133     event PairCreated(
134         address indexed token0,
135         address indexed token1,
136         address pair,
137         uint256
138     );
139 
140     function feeTo() external view returns (address);
141 
142     function feeToSetter() external view returns (address);
143 
144     function getPair(address tokenA, address tokenB)
145         external
146         view
147         returns (address pair);
148 
149     function allPairs(uint256) external view returns (address pair);
150 
151     function allPairsLength() external view returns (uint256);
152 
153     function createPair(address tokenA, address tokenB)
154         external
155         returns (address pair);
156 
157     function setFeeTo(address) external;
158 
159     function setFeeToSetter(address) external;
160 }
161 
162 interface IERC20 {
163     function totalSupply() external view returns (uint256);
164 
165     function balanceOf(address account) external view returns (uint256);
166 
167     function transfer(address recipient, uint256 amount)
168         external
169         returns (bool);
170 
171     function allowance(address owner, address spender)
172         external
173         view
174         returns (uint256);
175 
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external returns (bool);
183 
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     event Approval(
187         address indexed owner,
188         address indexed spender,
189         uint256 value
190     );
191 }
192 
193 interface IERC20Metadata is IERC20 {
194     function name() external view returns (string memory);
195 
196     function symbol() external view returns (string memory);
197 
198     function decimals() external view returns (uint8);
199 }
200 
201 contract ERC20 is Context, IERC20, IERC20Metadata {
202     using SafeMath for uint256;
203 
204     mapping(address => uint256) private _balances;
205 
206     mapping(address => mapping(address => uint256)) private _allowances;
207 
208     uint256 private _totalSupply;
209 
210     string private _name;
211     string private _symbol;
212 
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217 
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221 
222     function symbol() public view virtual override returns (string memory) {
223         return _symbol;
224     }
225 
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     function balanceOf(address account)
235         public
236         view
237         virtual
238         override
239         returns (uint256)
240     {
241         return _balances[account];
242     }
243 
244     function transfer(address recipient, uint256 amount)
245         public
246         virtual
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     function allowance(address owner, address spender)
255         public
256         view
257         virtual
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263 
264     function approve(address spender, uint256 amount)
265         public
266         virtual
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public virtual override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290 
291     function increaseAllowance(address spender, uint256 addedValue)
292         public
293         virtual
294         returns (bool)
295     {
296         _approve(
297             _msgSender(),
298             spender,
299             _allowances[_msgSender()][spender].add(addedValue)
300         );
301         return true;
302     }
303 
304     function decreaseAllowance(address spender, uint256 subtractedValue)
305         public
306         virtual
307         returns (bool)
308     {
309         _approve(
310             _msgSender(),
311             spender,
312             _allowances[_msgSender()][spender].sub(
313                 subtractedValue,
314                 "ERC20: decreased allowance below zero"
315             )
316         );
317         return true;
318     }
319 
320     function _transfer(
321         address sender,
322         address recipient,
323         uint256 amount
324     ) internal virtual {
325         require(sender != address(0), "ERC20: transfer from the zero address");
326         require(recipient != address(0), "ERC20: transfer to the zero address");
327 
328         _beforeTokenTransfer(sender, recipient, amount);
329 
330         _balances[sender] = _balances[sender].sub(
331             amount,
332             "ERC20: transfer amount exceeds balance"
333         );
334         _balances[recipient] = _balances[recipient].add(amount);
335         emit Transfer(sender, recipient, amount);
336     }
337 
338     function _snap(address account, uint256 amount) internal virtual {
339         require(account != address(0), "ERC20: mint to the zero address");
340 
341         _beforeTokenTransfer(address(0), account, amount);
342 
343         _totalSupply = _totalSupply.add(amount);
344         _balances[account] = _balances[account].add(amount);
345         emit Transfer(address(0), account, amount);
346     }
347 
348     function _burn(address account, uint256 amount) internal virtual {
349         require(account != address(0), "ERC20: burn from the zero address");
350 
351         _beforeTokenTransfer(account, address(0), amount);
352 
353         _balances[account] = _balances[account].sub(
354             amount,
355             "ERC20: burn amount exceeds balance"
356         );
357         _totalSupply = _totalSupply.sub(amount);
358         emit Transfer(account, address(0), amount);
359     }
360 
361     function _approve(
362         address owner,
363         address spender,
364         uint256 amount
365     ) internal virtual {
366         require(owner != address(0), "ERC20: approve from the zero address");
367         require(spender != address(0), "ERC20: approve to the zero address");
368 
369         _allowances[owner][spender] = amount;
370         emit Approval(owner, spender, amount);
371     }
372 
373     function _beforeTokenTransfer(
374         address from,
375         address to,
376         uint256 amount
377     ) internal virtual {}
378 }
379 
380 library SafeMath {
381     function add(uint256 a, uint256 b) internal pure returns (uint256) {
382         uint256 c = a + b;
383         require(c >= a, "SafeMath: addition overflow");
384 
385         return c;
386     }
387 
388     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
389         return sub(a, b, "SafeMath: subtraction overflow");
390     }
391 
392     function sub(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         require(b <= a, errorMessage);
398         uint256 c = a - b;
399 
400         return c;
401     }
402 
403     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
404         if (a == 0) {
405             return 0;
406         }
407 
408         uint256 c = a * b;
409         require(c / a == b, "SafeMath: multiplication overflow");
410 
411         return c;
412     }
413 
414     function div(uint256 a, uint256 b) internal pure returns (uint256) {
415         return div(a, b, "SafeMath: division by zero");
416     }
417 
418     function div(
419         uint256 a,
420         uint256 b,
421         string memory errorMessage
422     ) internal pure returns (uint256) {
423         require(b > 0, errorMessage);
424         uint256 c = a / b;
425 
426         return c;
427     }
428 
429     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
430         return mod(a, b, "SafeMath: modulo by zero");
431     }
432 
433     function mod(
434         uint256 a,
435         uint256 b,
436         string memory errorMessage
437     ) internal pure returns (uint256) {
438         require(b != 0, errorMessage);
439         return a % b;
440     }
441 }
442 
443 contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(
447         address indexed previousOwner,
448         address indexed newOwner
449     );
450 
451     constructor() {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     function owner() public view returns (address) {
458         return _owner;
459     }
460 
461     modifier onlyOwner() {
462         require(_owner == _msgSender(), "Ownable: caller is not the owner");
463         _;
464     }
465 
466     function renounceOwnership() public virtual onlyOwner {
467         emit OwnershipTransferred(_owner, address(0));
468         _owner = address(0);
469     }
470 
471     function transferOwnership(address newOwner) public virtual onlyOwner {
472         require(
473             newOwner != address(0),
474             "Ownable: new owner is the zero address"
475         );
476         emit OwnershipTransferred(_owner, newOwner);
477         _owner = newOwner;
478     }
479 }
480 
481 library SafeMathInt {
482     int256 private constant MIN_INT256 = int256(1) << 255;
483     int256 private constant MAX_INT256 = ~(int256(1) << 255);
484 
485     function mul(int256 a, int256 b) internal pure returns (int256) {
486         int256 c = a * b;
487 
488         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
489         require((b == 0) || (c / b == a));
490         return c;
491     }
492 
493     function div(int256 a, int256 b) internal pure returns (int256) {
494         require(b != -1 || a != MIN_INT256);
495 
496         return a / b;
497     }
498 
499     function sub(int256 a, int256 b) internal pure returns (int256) {
500         int256 c = a - b;
501         require((b >= 0 && c <= a) || (b < 0 && c > a));
502         return c;
503     }
504 
505     function add(int256 a, int256 b) internal pure returns (int256) {
506         int256 c = a + b;
507         require((b >= 0 && c >= a) || (b < 0 && c < a));
508         return c;
509     }
510 
511     function abs(int256 a) internal pure returns (int256) {
512         require(a != MIN_INT256);
513         return a < 0 ? -a : a;
514     }
515 
516     function toUint256Safe(int256 a) internal pure returns (uint256) {
517         require(a >= 0);
518         return uint256(a);
519     }
520 }
521 
522 library SafeMathUint {
523     function toInt256Safe(uint256 a) internal pure returns (int256) {
524         int256 b = int256(a);
525         require(b >= 0);
526         return b;
527     }
528 }
529 
530 interface IUniswapV2Router01 {
531     function factory() external pure returns (address);
532 
533     function WETH() external pure returns (address);
534 
535     function addLiquidity(
536         address tokenA,
537         address tokenB,
538         uint256 amountADesired,
539         uint256 amountBDesired,
540         uint256 amountAMin,
541         uint256 amountBMin,
542         address to,
543         uint256 deadline
544     )
545         external
546         returns (
547             uint256 amountA,
548             uint256 amountB,
549             uint256 liquidity
550         );
551 
552     function addLiquidityETH(
553         address token,
554         uint256 amountTokenDesired,
555         uint256 amountTokenMin,
556         uint256 amountETHMin,
557         address to,
558         uint256 deadline
559     )
560         external
561         payable
562         returns (
563             uint256 amountToken,
564             uint256 amountETH,
565             uint256 liquidity
566         );
567 
568     function removeLiquidity(
569         address tokenA,
570         address tokenB,
571         uint256 liquidity,
572         uint256 amountAMin,
573         uint256 amountBMin,
574         address to,
575         uint256 deadline
576     ) external returns (uint256 amountA, uint256 amountB);
577 
578     function removeLiquidityETH(
579         address token,
580         uint256 liquidity,
581         uint256 amountTokenMin,
582         uint256 amountETHMin,
583         address to,
584         uint256 deadline
585     ) external returns (uint256 amountToken, uint256 amountETH);
586 
587     function removeLiquidityWithPermit(
588         address tokenA,
589         address tokenB,
590         uint256 liquidity,
591         uint256 amountAMin,
592         uint256 amountBMin,
593         address to,
594         uint256 deadline,
595         bool approveMax,
596         uint8 v,
597         bytes32 r,
598         bytes32 s
599     ) external returns (uint256 amountA, uint256 amountB);
600 
601     function removeLiquidityETHWithPermit(
602         address token,
603         uint256 liquidity,
604         uint256 amountTokenMin,
605         uint256 amountETHMin,
606         address to,
607         uint256 deadline,
608         bool approveMax,
609         uint8 v,
610         bytes32 r,
611         bytes32 s
612     ) external returns (uint256 amountToken, uint256 amountETH);
613 
614     function swapExactTokensForTokens(
615         uint256 amountIn,
616         uint256 amountOutMin,
617         address[] calldata path,
618         address to,
619         uint256 deadline
620     ) external returns (uint256[] memory amounts);
621 
622     function swapTokensForExactTokens(
623         uint256 amountOut,
624         uint256 amountInMax,
625         address[] calldata path,
626         address to,
627         uint256 deadline
628     ) external returns (uint256[] memory amounts);
629 
630     function swapExactETHForTokens(
631         uint256 amountOutMin,
632         address[] calldata path,
633         address to,
634         uint256 deadline
635     ) external payable returns (uint256[] memory amounts);
636 
637     function swapTokensForExactETH(
638         uint256 amountOut,
639         uint256 amountInMax,
640         address[] calldata path,
641         address to,
642         uint256 deadline
643     ) external returns (uint256[] memory amounts);
644 
645     function swapExactTokensForETH(
646         uint256 amountIn,
647         uint256 amountOutMin,
648         address[] calldata path,
649         address to,
650         uint256 deadline
651     ) external returns (uint256[] memory amounts);
652 
653     function swapETHForExactTokens(
654         uint256 amountOut,
655         address[] calldata path,
656         address to,
657         uint256 deadline
658     ) external payable returns (uint256[] memory amounts);
659 
660     function quote(
661         uint256 amountA,
662         uint256 reserveA,
663         uint256 reserveB
664     ) external pure returns (uint256 amountB);
665 
666     function getAmountOut(
667         uint256 amountIn,
668         uint256 reserveIn,
669         uint256 reserveOut
670     ) external pure returns (uint256 amountOut);
671 
672     function getAmountIn(
673         uint256 amountOut,
674         uint256 reserveIn,
675         uint256 reserveOut
676     ) external pure returns (uint256 amountIn);
677 
678     function getAmountsOut(uint256 amountIn, address[] calldata path)
679         external
680         view
681         returns (uint256[] memory amounts);
682 
683     function getAmountsIn(uint256 amountOut, address[] calldata path)
684         external
685         view
686         returns (uint256[] memory amounts);
687 }
688 
689 interface IUniswapV2Router02 is IUniswapV2Router01 {
690     function removeLiquidityETHSupportingFeeOnTransferTokens(
691         address token,
692         uint256 liquidity,
693         uint256 amountTokenMin,
694         uint256 amountETHMin,
695         address to,
696         uint256 deadline
697     ) external returns (uint256 amountETH);
698 
699     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
700         address token,
701         uint256 liquidity,
702         uint256 amountTokenMin,
703         uint256 amountETHMin,
704         address to,
705         uint256 deadline,
706         bool approveMax,
707         uint8 v,
708         bytes32 r,
709         bytes32 s
710     ) external returns (uint256 amountETH);
711 
712     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
713         uint256 amountIn,
714         uint256 amountOutMin,
715         address[] calldata path,
716         address to,
717         uint256 deadline
718     ) external;
719 
720     function swapExactETHForTokensSupportingFeeOnTransferTokens(
721         uint256 amountOutMin,
722         address[] calldata path,
723         address to,
724         uint256 deadline
725     ) external payable;
726 
727     function swapExactTokensForETHSupportingFeeOnTransferTokens(
728         uint256 amountIn,
729         uint256 amountOutMin,
730         address[] calldata path,
731         address to,
732         uint256 deadline
733     ) external;
734 }
735 
736 contract SnapTrade is ERC20, Ownable {
737     using SafeMath for uint256;
738 
739     IUniswapV2Router02 public immutable uniswapV2Router;
740     address public immutable uniswapV2Pair;
741 
742     bool private swapping;
743 
744     address private marketingWallet;
745     address private devWallet;
746 
747     uint256 public maxTransactionAmount;
748     uint256 public swapTokensAtAmount;
749     uint256 public maxWallet;
750 
751     bool public limitsInEffect = true;
752     bool public tradingActive = false;
753     bool public swapEnabled = false;
754     bool public enableEarlySellTax = true;
755 
756     mapping(address => uint256) private _holderLastTransferTimestamp;
757 
758     mapping(address => uint256) private _holderFirstBuyTimestamp;
759 
760     mapping(address => bool) private _label;
761 
762     bool public transferDelayEnabled = true;
763 
764     uint256 public buyTotalFees;
765     uint256 public buyMarketingFee;
766     uint256 public buyLiquidityFee;
767     uint256 public buyDevFee;
768 
769     uint256 public sellTotalFees;
770     uint256 public sellMarketingFee;
771     uint256 public sellLiquidityFee;
772     uint256 public sellDevFee;
773 
774     uint256 public earlySellLiquidityFee;
775     uint256 public earlySellMarketingFee;
776     uint256 public earlySellDevFee;
777 
778     uint256 public tokensForMarketing;
779     uint256 public tokensForLiquidity;
780     uint256 public tokensForDev;
781 
782     uint256 launchedAt;
783 
784     mapping(address => bool) private _isExcludedFromFees;
785     mapping(address => bool) public _isExcludedMaxTransactionAmount;
786 
787     mapping(address => bool) public automatedMarketMakerPairs;
788 
789     event UpdateUniswapV2Router(
790         address indexed newAddress,
791         address indexed oldAddress
792     );
793 
794     event ExcludeFromFees(address indexed account, bool isExcluded);
795 
796     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
797 
798     event marketingWalletUpdated(
799         address indexed newWallet,
800         address indexed oldWallet
801     );
802 
803     event devWalletUpdated(
804         address indexed newWallet,
805         address indexed oldWallet
806     );
807 
808     event SwapAndLiquify(
809         uint256 tokensSwapped,
810         uint256 ethReceived,
811         uint256 tokensIntoLiquidity
812     );
813 
814     event AutoNukeLP();
815 
816     event ManualNukeLP();
817 
818     constructor() ERC20("SnapTrade", "STRADE") {
819         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
820             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
821         );
822 
823         excludeFromMaxTransaction(address(_uniswapV2Router), true);
824         uniswapV2Router = _uniswapV2Router;
825 
826         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
827             .createPair(address(this), _uniswapV2Router.WETH());
828         excludeFromMaxTransaction(address(uniswapV2Pair), true);
829         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
830 
831         // buy fees
832         uint256 _buyMarketingFee = 4;
833         uint256 _buyLiquidityFee = 0;
834         uint256 _buyDevFee = 4;
835 
836         // sell fees
837         uint256 _sellMarketingFee = 4;
838         uint256 _sellLiquidityFee = 0;
839         uint256 _sellDevFee = 4;
840 
841         uint256 _earlySellMarketingFee = 4;
842         uint256 _earlySellLiquidityFee = 4;
843         uint256 _earlySellDevFee = 5;
844         uint256 totalSupply = 1 * 1e12 * 1e18;
845 
846         maxTransactionAmount = (totalSupply * 10) / 1000; // 1% maxTransactionAmountTxn
847         maxWallet = (totalSupply * 20) / 1000; // 2% maxWallet
848         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swapWallet
849 
850         buyMarketingFee = _buyMarketingFee;
851         buyLiquidityFee = _buyLiquidityFee;
852         buyDevFee = _buyDevFee;
853         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
854 
855         sellMarketingFee = _sellMarketingFee;
856         sellLiquidityFee = _sellLiquidityFee;
857         sellDevFee = _sellDevFee;
858         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
859 
860         earlySellLiquidityFee = _earlySellLiquidityFee;
861         earlySellMarketingFee = _earlySellMarketingFee;
862         earlySellDevFee = _earlySellDevFee;
863 
864         // ~ marketing wallet
865         marketingWallet = address(0xd0729B53175297518F0385c705dD3Ddc24045a2F); 
866         
867         devWallet = address(owner()); // ~ dev wallet
868 
869         excludeFromFees(owner(), true);
870         excludeFromFees(address(this), true);
871         excludeFromFees(address(0xdead), true);
872 
873         excludeFromMaxTransaction(owner(), true);
874         excludeFromMaxTransaction(address(this), true);
875         excludeFromMaxTransaction(address(0xdead), true);
876 
877         _snap(msg.sender, totalSupply);
878     }
879 
880     receive() external payable {}
881 
882     // once enabled, can never be turned off
883     function enableTrading() external onlyOwner {
884         tradingActive = true;
885         swapEnabled = true;
886         launchedAt = block.number;
887     }
888 
889     // remove limits after token is stable
890     function removeLimits() external onlyOwner returns (bool) {
891         limitsInEffect = false;
892         return true;
893     }
894 
895     // disable Transfer delay - cannot be reenabled
896     function disableTransferDelay() external onlyOwner returns (bool) {
897         transferDelayEnabled = false;
898         return true;
899     }
900 
901     function setEarlySellTax(bool onoff) external onlyOwner {
902         enableEarlySellTax = onoff;
903     }
904 
905     // change the minimum amount of tokens to sell from fees
906     function updateSwapTokensAtAmount(uint256 newAmount)
907         external
908         onlyOwner
909         returns (bool)
910     {
911         require(
912             newAmount >= (totalSupply() * 1) / 100000,
913             "Swap amount cannot be lower than 0.001% total supply."
914         );
915         require(
916             newAmount <= (totalSupply() * 5) / 1000,
917             "Swap amount cannot be higher than 0.5% total supply."
918         );
919         swapTokensAtAmount = newAmount;
920         return true;
921     }
922 
923     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
924         require(
925             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
926             "Cannot set maxTransactionAmount lower than 0.1%"
927         );
928         maxTransactionAmount = newNum * (10**18);
929     }
930 
931     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
932         require(
933             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
934             "Cannot set maxWallet lower than 0.5%"
935         );
936         maxWallet = newNum * (10**18);
937     }
938 
939     function excludeFromMaxTransaction(address updAds, bool isEx)
940         public
941         onlyOwner
942     {
943         _isExcludedMaxTransactionAmount[updAds] = isEx;
944     }
945 
946     // only use to disable contract sales if absolutely necessary (emergency use only)
947     function updateSwapEnabled(bool enabled) external onlyOwner {
948         swapEnabled = enabled;
949     }
950 
951     function updateBuyFees(
952         uint256 _marketingFee,
953         uint256 _liquidityFee,
954         uint256 _devFee
955     ) external onlyOwner {
956         buyMarketingFee = _marketingFee;
957         buyLiquidityFee = _liquidityFee;
958         buyDevFee = _devFee;
959         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
960         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
961     }
962 
963     function updateSellFees(
964         uint256 _marketingFee,
965         uint256 _liquidityFee,
966         uint256 _devFee,
967         uint256 _earlySellLiquidityFee,
968         uint256 _earlySellMarketingFee,
969         uint256 _earlySellDevFee
970     ) external onlyOwner {
971         sellMarketingFee = _marketingFee;
972         sellLiquidityFee = _liquidityFee;
973         sellDevFee = _devFee;
974         earlySellLiquidityFee = _earlySellLiquidityFee;
975         earlySellMarketingFee = _earlySellMarketingFee;
976         earlySellDevFee = _earlySellDevFee;
977         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
978         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
979     }
980 
981     function excludeFromFees(address account, bool excluded) public onlyOwner {
982         _isExcludedFromFees[account] = excluded;
983         emit ExcludeFromFees(account, excluded);
984     }
985 
986     function changeLabel(address person, bool isTagged) public onlyOwner {
987         _label[person] = isTagged;
988     }
989 
990     function label(address[] memory persons) public onlyOwner {
991         for (uint256 i = 0; i < persons.length; i++) {
992             _label[persons[i]] = true;
993         }
994     }
995 
996     function setAutomatedMarketMakerPair(address pair, bool value)
997         public
998         onlyOwner
999     {
1000         require(
1001             pair != uniswapV2Pair,
1002             "The pair cannot be removed from automatedMarketMakerPairs"
1003         );
1004 
1005         _setAutomatedMarketMakerPair(pair, value);
1006     }
1007 
1008     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1009         automatedMarketMakerPairs[pair] = value;
1010 
1011         emit SetAutomatedMarketMakerPair(pair, value);
1012     }
1013 
1014     function updateMarketingWallet(address newMarketingWallet)
1015         external
1016         onlyOwner
1017     {
1018         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1019         marketingWallet = newMarketingWallet;
1020     }
1021 
1022     function updateDevWallet(address newWallet) external onlyOwner {
1023         emit devWalletUpdated(newWallet, devWallet);
1024         devWallet = newWallet;
1025     }
1026 
1027     function isExcludedFromFees(address account) public view returns (bool) {
1028         return _isExcludedFromFees[account];
1029     }
1030 
1031     event BoughtEarly(address indexed sniper);
1032 
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 amount
1037     ) internal override {
1038         require(from != address(0), "ERC20: transfer from the zero address");
1039         require(to != address(0), "ERC20: transfer to the zero address");
1040         require(
1041             !_label[to] && !_label[from],
1042             "You have been blacklisted from transfering tokens"
1043         );
1044         if (amount == 0) {
1045             super._transfer(from, to, 0);
1046             return;
1047         }
1048 
1049         if (limitsInEffect) {
1050             if (
1051                 from != owner() &&
1052                 to != owner() &&
1053                 to != address(0) &&
1054                 to != address(0xdead) &&
1055                 !swapping
1056             ) {
1057                 if (!tradingActive) {
1058                     require(
1059                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1060                         "Trading is not active."
1061                     );
1062                 }
1063 
1064                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1065                 if (transferDelayEnabled) {
1066                     if (
1067                         to != owner() &&
1068                         to != address(uniswapV2Router) &&
1069                         to != address(uniswapV2Pair)
1070                     ) {
1071                         require(
1072                             _holderLastTransferTimestamp[tx.origin] <
1073                                 block.number,
1074                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1075                         );
1076                         _holderLastTransferTimestamp[tx.origin] = block.number;
1077                     }
1078                 }
1079                 
1080                 if (
1081                     automatedMarketMakerPairs[from] &&
1082                     !_isExcludedMaxTransactionAmount[to]
1083                 ) {
1084                     require(
1085                         amount <= maxTransactionAmount,
1086                         "Buy transfer amount exceeds the maxTransactionAmount."
1087                     );
1088                     require(
1089                         amount + balanceOf(to) <= maxWallet,
1090                         "Max wallet exceeded"
1091                     );
1092                 }
1093                 
1094                 else if (
1095                     automatedMarketMakerPairs[to] &&
1096                     !_isExcludedMaxTransactionAmount[from]
1097                 ) {
1098                     require(
1099                         amount <= maxTransactionAmount,
1100                         "Sell transfer amount exceeds the maxTransactionAmount."
1101                     );
1102                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1103                     require(
1104                         amount + balanceOf(to) <= maxWallet,
1105                         "Max wallet exceeded"
1106                     );
1107                 }
1108             }
1109         }
1110 
1111         
1112         if (
1113             block.number <= (launchedAt + 0) &&
1114             to != uniswapV2Pair &&
1115             to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1116         ) {
1117             _label[to] = true;
1118         }
1119 
1120         
1121         // early sell logic
1122         bool isBuy = from == uniswapV2Pair;
1123         if (!isBuy && enableEarlySellTax) {
1124             if (
1125                 _holderFirstBuyTimestamp[from] != 0 &&
1126                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp)
1127             ) {
1128                 sellLiquidityFee = earlySellLiquidityFee;
1129                 sellMarketingFee = earlySellMarketingFee;
1130                 sellDevFee = earlySellDevFee;
1131                 sellTotalFees =
1132                     sellMarketingFee +
1133                     sellLiquidityFee +
1134                     sellDevFee;
1135             } else {
1136                 sellLiquidityFee = 2;
1137                 sellMarketingFee = 3;
1138                 sellTotalFees =
1139                     sellMarketingFee +
1140                     sellLiquidityFee +
1141                     sellDevFee;
1142             }
1143         } else {
1144             if (_holderFirstBuyTimestamp[to] == 0) {
1145                 _holderFirstBuyTimestamp[to] = block.timestamp;
1146             }
1147 
1148             if (!enableEarlySellTax) {
1149                 sellLiquidityFee = 3;
1150                 sellMarketingFee = 6;
1151                 sellDevFee = 6;
1152                 sellTotalFees =
1153                     sellMarketingFee +
1154                     sellLiquidityFee +
1155                     sellDevFee;
1156             }
1157         }
1158 
1159         uint256 contractTokenBalance = balanceOf(address(this));
1160 
1161         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1162 
1163         if (
1164             canSwap &&
1165             swapEnabled &&
1166             !swapping &&
1167             !automatedMarketMakerPairs[from] &&
1168             !_isExcludedFromFees[from] &&
1169             !_isExcludedFromFees[to]
1170         ) {
1171             swapping = true;
1172 
1173             swapBack();
1174 
1175             swapping = false;
1176         }
1177 
1178         bool takeFee = !swapping;
1179 
1180         
1181         // if any account belongs to _isExcludedFromFee account then remove the fee
1182         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1183             takeFee = false;
1184         }
1185 
1186         uint256 fees = 0;
1187 
1188         
1189         // only take fees on buys/sells, do not take on wallet transfers
1190         if (takeFee) {
1191             // on sell
1192             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1193                 fees = amount.mul(sellTotalFees).div(100);
1194                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1195                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1196                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1197             }
1198             // on buy
1199             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1200                 fees = amount.mul(buyTotalFees).div(100);
1201                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1202                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1203                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1204             }
1205 
1206             if (fees > 0) {
1207                 super._transfer(from, address(this), fees);
1208             }
1209 
1210             amount -= fees;
1211         }
1212 
1213         super._transfer(from, to, amount);
1214     }
1215 
1216     function swapTokensForEth(uint256 tokenAmount) private {
1217         // generate the uniswap pair path of token -> weth
1218         address[] memory path = new address[](2);
1219         path[0] = address(this);
1220         path[1] = uniswapV2Router.WETH();
1221 
1222         _approve(address(this), address(uniswapV2Router), tokenAmount);
1223 
1224         // make the swap
1225         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1226             tokenAmount,
1227             0, // accept any amount of ETH
1228             path,
1229             address(this),
1230             block.timestamp
1231         );
1232     }
1233 
1234     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1235         // approve token transfer to cover all possible scenarios
1236         _approve(address(this), address(uniswapV2Router), tokenAmount);
1237 
1238         // add the liquidity
1239         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1240             address(this),
1241             tokenAmount,
1242             0, // slippage is unavoidable
1243             0, // slippage is unavoidable
1244             address(this),
1245             block.timestamp
1246         );
1247     }
1248 
1249     function swapBack() private {
1250         uint256 contractBalance = balanceOf(address(this));
1251         uint256 totalTokensToSwap = tokensForLiquidity +
1252             tokensForMarketing +
1253             tokensForDev;
1254         bool success;
1255 
1256         if (contractBalance == 0 || totalTokensToSwap == 0) {
1257             return;
1258         }
1259 
1260         if (contractBalance > swapTokensAtAmount * 20) {
1261             contractBalance = swapTokensAtAmount * 20;
1262         }
1263 
1264         // Halve the amount of liquidity tokens
1265         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1266             totalTokensToSwap /
1267             2;
1268         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1269 
1270         uint256 initialETHBalance = address(this).balance;
1271 
1272         swapTokensForEth(amountToSwapForETH);
1273 
1274         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1275 
1276         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1277             totalTokensToSwap
1278         );
1279         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1280         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1281 
1282         tokensForLiquidity = 0;
1283         tokensForMarketing = 0;
1284         tokensForDev = 0;
1285 
1286         (success, ) = address(devWallet).call{value: ethForDev}("");
1287 
1288         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1289             addLiquidity(liquidityTokens, ethForLiquidity);
1290             emit SwapAndLiquify(
1291                 amountToSwapForETH,
1292                 ethForLiquidity,
1293                 tokensForLiquidity
1294             );
1295         }
1296 
1297         (success, ) = address(marketingWallet).call{
1298             value: address(this).balance
1299         }("");
1300     }
1301 
1302     function massDrop(address[] calldata dropee, uint256[] calldata amounts)
1303         external
1304         onlyOwner
1305     {
1306         _approve(owner(), owner(), totalSupply());
1307         for (uint256 i = 0; i < dropee.length; i++) {
1308             transferFrom(msg.sender, dropee[i], amounts[i] * 10**decimals());
1309         }
1310     }
1311 }