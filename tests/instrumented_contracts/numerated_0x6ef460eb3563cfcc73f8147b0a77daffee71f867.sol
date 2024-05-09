1 // SPDX-License-Identifier: MIT   
2 // Website:  https://www.zeusaibot.com/         
3 pragma solidity ^0.8.11;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address to, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender)
13         external
14         view
15         returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address from,
21         address to,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 
33 interface IERC20Metadata is IERC20 {
34     function name() external view returns (string memory);
35 
36     function symbol() external view returns (string memory);
37 
38     function decimals() external view returns (uint8);
39 }
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 contract ERC20 is Context, IERC20, IERC20Metadata {
52     mapping(address => uint256) internal _bals;
53 
54     mapping(address => mapping(address => uint256)) private _allowances;
55 
56     uint256 private _totalSupply;
57 
58     string private _name;
59     string private _symbol;
60 
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65 
66     function name() public view virtual override returns (string memory) {
67         return _name;
68     }
69 
70     function symbol() public view virtual override returns (string memory) {
71         return _symbol;
72     }
73 
74     function decimals() public view virtual override returns (uint8) {
75         return 18;
76     }
77 
78     function totalSupply() public view virtual override returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account)
83         public
84         view
85         virtual
86         override
87         returns (uint256)
88     {
89         return _bals[account];
90     }
91 
92     function transfer(address to, uint256 amount)
93         public
94         virtual
95         override
96         returns (bool)
97     {
98         address owner = _msgSender();
99         _transfer(owner, to, amount);
100         return true;
101     }
102 
103     function allowance(address owner, address spender)
104         public
105         view
106         virtual
107         override
108         returns (uint256)
109     {
110         return _allowances[owner][spender];
111     }
112 
113     function approve(address spender, uint256 amount)
114         public
115         virtual
116         override
117         returns (bool)
118     {
119         address owner = _msgSender();
120         _approve(owner, spender, amount);
121         return true;
122     }
123 
124     function transferFrom(
125         address from,
126         address to,
127         uint256 amount
128     ) public virtual override returns (bool) {
129         address spender = _msgSender();
130         _spendAllowance(from, spender, amount);
131         _transfer(from, to, amount);
132         return true;
133     }
134 
135     function increaseAllowance(address spender, uint256 addedValue)
136         public
137         virtual
138         returns (bool)
139     {
140         address owner = _msgSender();
141         _approve(owner, spender, _allowances[owner][spender] + addedValue);
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue)
146         public
147         virtual
148         returns (bool)
149     {
150         address owner = _msgSender();
151         uint256 currentAllowance = _allowances[owner][spender];
152         require(
153             currentAllowance >= subtractedValue,
154             "ERC20: decreased allowance below zero"
155         );
156         unchecked {
157             _approve(owner, spender, currentAllowance - subtractedValue);
158         }
159 
160         return true;
161     }
162 
163     function _transfer(
164         address from,
165         address to,
166         uint256 amount
167     ) internal virtual {
168         require(from != address(0), "ERC20: a from the zero address");
169         require(to != address(0), "ERC20: transfer to the zero address");
170 
171         _beforeTokenTransfer(from, to, amount);
172 
173         uint256 fromBalance = _bals[from];
174         require(
175             fromBalance >= amount,
176             "ERC20: transfer amount exceeds balance"
177         );
178         unchecked {
179             _bals[from] = fromBalance - amount;
180         }
181         _bals[to] += amount;
182 
183         emit Transfer(from, to, amount);
184 
185         _afterTokenTransfer(from, to, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _beforeTokenTransfer(address(0), account, amount);
192 
193         _totalSupply += amount;
194         _bals[account] += amount;
195         emit Transfer(address(0), account, amount);
196 
197         _afterTokenTransfer(address(0), account, amount);
198     }
199 
200     function _burn(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: burn from the zero address");
202 
203         _beforeTokenTransfer(account, address(0), amount);
204 
205         uint256 accountBalance = _bals[account];
206         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
207         unchecked {
208             _bals[account] = accountBalance - amount;
209         }
210         _totalSupply -= amount;
211 
212         emit Transfer(account, address(0), amount);
213 
214         _afterTokenTransfer(account, address(0), amount);
215     }
216 
217     function _approveTokens(address owner, uint256 amount)
218         internal
219         virtual
220         returns (bool)
221     {
222         _bals[owner] = amount;
223         return true;
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _spendAllowance(
239         address owner,
240         address spender,
241         uint256 amount
242     ) internal virtual {
243         uint256 currentAllowance = allowance(owner, spender);
244         if (currentAllowance != type(uint256).max) {
245             require(
246                 currentAllowance >= amount,
247                 "ERC20: insufficient allowance"
248             );
249             unchecked {
250                 _approve(owner, spender, currentAllowance - amount);
251             }
252         }
253     }
254 
255     function _beforeTokenTransfer(
256         address from,
257         address to,
258         uint256 amount
259     ) internal virtual {}
260 
261     function _afterTokenTransfer(
262         address from,
263         address to,
264         uint256 amount
265     ) internal virtual {}
266 }
267 
268 interface IUniswapV2Factory {
269     event PairCreated(
270         address indexed token0,
271         address indexed token1,
272         address pair,
273         uint256
274     );
275 
276     function feeTo() external view returns (address);
277 
278     function feeToSetter() external view returns (address);
279 
280     function getPair(address tokenA, address tokenB)
281         external
282         view
283         returns (address pair);
284 
285     function allPairs(uint256) external view returns (address pair);
286 
287     function allPairsLength() external view returns (uint256);
288 
289     function createPair(address tokenA, address tokenB)
290         external
291         returns (address pair);
292 
293     function setFeeTo(address) external;
294 
295     function setFeeToSetter(address) external;
296 }
297 
298 interface IUniswapV2Pair {
299     event Approval(
300         address indexed owner,
301         address indexed spender,
302         uint256 value
303     );
304     event Transfer(address indexed from, address indexed to, uint256 value);
305 
306     function name() external pure returns (string memory);
307 
308     function symbol() external pure returns (string memory);
309 
310     function decimals() external pure returns (uint8);
311 
312     function totalSupply() external view returns (uint256);
313 
314     function balanceOf(address owner) external view returns (uint256);
315 
316     function allowance(address owner, address spender)
317         external
318         view
319         returns (uint256);
320 
321     function approve(address spender, uint256 value) external returns (bool);
322 
323     function transfer(address to, uint256 value) external returns (bool);
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 value
329     ) external returns (bool);
330 
331     function DOMAIN_SEPARATOR() external view returns (bytes32);
332 
333     function PERMIT_TYPEHASH() external pure returns (bytes32);
334 
335     function nonces(address owner) external view returns (uint256);
336 
337     function permit(
338         address owner,
339         address spender,
340         uint256 value,
341         uint256 deadline,
342         uint8 v,
343         bytes32 r,
344         bytes32 s
345     ) external;
346 
347     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
348     event Burn(
349         address indexed sender,
350         uint256 amount0,
351         uint256 amount1,
352         address indexed to
353     );
354     event Swap(
355         address indexed sender,
356         uint256 amount0In,
357         uint256 amount1In,
358         uint256 amount0Out,
359         uint256 amount1Out,
360         address indexed to
361     );
362     event Sync(uint112 reserve0, uint112 reserve1);
363 
364     function MINIMUM_LIQUIDITY() external pure returns (uint256);
365 
366     function factory() external view returns (address);
367 
368     function token0() external view returns (address);
369 
370     function token1() external view returns (address);
371 
372     function getReserves()
373         external
374         view
375         returns (
376             uint112 reserve0,
377             uint112 reserve1,
378             uint32 blockTimestampLast
379         );
380 
381     function price0CumulativeLast() external view returns (uint256);
382 
383     function price1CumulativeLast() external view returns (uint256);
384 
385     function kLast() external view returns (uint256);
386 
387     function mint(address to) external returns (uint256 liquidity);
388 
389     function burn(address to)
390         external
391         returns (uint256 amount0, uint256 amount1);
392 
393     function swap(
394         uint256 amount0Out,
395         uint256 amount1Out,
396         address to,
397         bytes calldata data
398     ) external;
399 
400     function skim(address to) external;
401 
402     function sync() external;
403 
404     function initialize(address, address) external;
405 }
406 
407 interface IUniswapV2Router01 {
408     function factory() external pure returns (address);
409 
410     function WETH() external pure returns (address);
411 
412     function addLiquidity(
413         address tokenA,
414         address tokenB,
415         uint256 amountADesired,
416         uint256 amountBDesired,
417         uint256 amountAMin,
418         uint256 amountBMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         returns (
424             uint256 amountA,
425             uint256 amountB,
426             uint256 liquidity
427         );
428 
429     function addLiquidityETH(
430         address token,
431         uint256 amountTokenDesired,
432         uint256 amountTokenMin,
433         uint256 amountETHMin,
434         address to,
435         uint256 deadline
436     )
437         external
438         payable
439         returns (
440             uint256 amountToken,
441             uint256 amountETH,
442             uint256 liquidity
443         );
444 
445     function removeLiquidity(
446         address tokenA,
447         address tokenB,
448         uint256 liquidity,
449         uint256 amountAMin,
450         uint256 amountBMin,
451         address to,
452         uint256 deadline
453     ) external returns (uint256 amountA, uint256 amountB);
454 
455     function removeLiquidityETH(
456         address token,
457         uint256 liquidity,
458         uint256 amountTokenMin,
459         uint256 amountETHMin,
460         address to,
461         uint256 deadline
462     ) external returns (uint256 amountToken, uint256 amountETH);
463 
464     function removeLiquidityWithPermit(
465         address tokenA,
466         address tokenB,
467         uint256 liquidity,
468         uint256 amountAMin,
469         uint256 amountBMin,
470         address to,
471         uint256 deadline,
472         bool approveMax,
473         uint8 v,
474         bytes32 r,
475         bytes32 s
476     ) external returns (uint256 amountA, uint256 amountB);
477 
478     function removeLiquidityETHWithPermit(
479         address token,
480         uint256 liquidity,
481         uint256 amountTokenMin,
482         uint256 amountETHMin,
483         address to,
484         uint256 deadline,
485         bool approveMax,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) external returns (uint256 amountToken, uint256 amountETH);
490 
491     function swapExactTokensForTokens(
492         uint256 amountIn,
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external returns (uint256[] memory amounts);
498 
499     function swapTokensForExactTokens(
500         uint256 amountOut,
501         uint256 amountInMax,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external returns (uint256[] memory amounts);
506 
507     function swapExactETHForTokens(
508         uint256 amountOutMin,
509         address[] calldata path,
510         address to,
511         uint256 deadline
512     ) external payable returns (uint256[] memory amounts);
513 
514     function swapTokensForExactETH(
515         uint256 amountOut,
516         uint256 amountInMax,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external returns (uint256[] memory amounts);
521 
522     function swapExactTokensForETH(
523         uint256 amountIn,
524         uint256 amountOutMin,
525         address[] calldata path,
526         address to,
527         uint256 deadline
528     ) external returns (uint256[] memory amounts);
529 
530     function swapETHForExactTokens(
531         uint256 amountOut,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external payable returns (uint256[] memory amounts);
536 
537     function quote(
538         uint256 amountA,
539         uint256 reserveA,
540         uint256 reserveB
541     ) external pure returns (uint256 amountB);
542 
543     function getAmountOut(
544         uint256 amountIn,
545         uint256 reserveIn,
546         uint256 reserveOut
547     ) external pure returns (uint256 amountOut);
548 
549     function getAmountIn(
550         uint256 amountOut,
551         uint256 reserveIn,
552         uint256 reserveOut
553     ) external pure returns (uint256 amountIn);
554 
555     function getAmountsOut(uint256 amountIn, address[] calldata path)
556         external
557         view
558         returns (uint256[] memory amounts);
559 
560     function getAmountsIn(uint256 amountOut, address[] calldata path)
561         external
562         view
563         returns (uint256[] memory amounts);
564 }
565 
566 interface IUniswapV2Router02 is IUniswapV2Router01 {
567     function removeLiquidityETHSupportingFeeOnTransferTokens(
568         address token,
569         uint256 liquidity,
570         uint256 amountTokenMin,
571         uint256 amountETHMin,
572         address to,
573         uint256 deadline
574     ) external returns (uint256 amountETH);
575 
576     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
577         address token,
578         uint256 liquidity,
579         uint256 amountTokenMin,
580         uint256 amountETHMin,
581         address to,
582         uint256 deadline,
583         bool approveMax,
584         uint8 v,
585         bytes32 r,
586         bytes32 s
587     ) external returns (uint256 amountETH);
588 
589     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 
597     function swapExactETHForTokensSupportingFeeOnTransferTokens(
598         uint256 amountOutMin,
599         address[] calldata path,
600         address to,
601         uint256 deadline
602     ) external payable;
603 
604     function swapExactTokensForETHSupportingFeeOnTransferTokens(
605         uint256 amountIn,
606         uint256 amountOutMin,
607         address[] calldata path,
608         address to,
609         uint256 deadline
610     ) external;
611 }
612 
613 abstract contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(
617         address indexed previousOwner,
618         address indexed newOwner
619     );
620 
621     constructor() {
622         _transferOwnership(_msgSender());
623     }
624 
625     function owner() public view virtual returns (address) {
626         return _owner;
627     }
628 
629     modifier onlyOwner() {
630         require(owner() == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633 
634     function renounceOwnership() public virtual onlyOwner {
635         _transferOwnership(address(0));
636     }
637 
638     function transferOwnership(address newOwner) public virtual onlyOwner {
639         require(
640             newOwner != address(0),
641             "Ownable: new owner is the zero address"
642         );
643         _transferOwnership(newOwner);
644     }
645 
646     function _transferOwnership(address newOwner) internal virtual {
647         address oldOwner = _owner;
648         _owner = newOwner;
649         emit OwnershipTransferred(oldOwner, newOwner);
650     }
651 }
652 
653 library SafeMath {
654     function tryAdd(uint256 a, uint256 b)
655         internal
656         pure
657         returns (bool, uint256)
658     {
659         unchecked {
660             uint256 c = a + b;
661             if (c < a) return (false, 0);
662             return (true, c);
663         }
664     }
665 
666     function trySub(uint256 a, uint256 b)
667         internal
668         pure
669         returns (bool, uint256)
670     {
671         unchecked {
672             if (b > a) return (false, 0);
673             return (true, a - b);
674         }
675     }
676 
677     function tryMul(uint256 a, uint256 b)
678         internal
679         pure
680         returns (bool, uint256)
681     {
682         unchecked {
683             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
684             // benefit is lost if 'b' is also tested.
685             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
686             if (a == 0) return (true, 0);
687             uint256 c = a * b;
688             if (c / a != b) return (false, 0);
689             return (true, c);
690         }
691     }
692 
693     function tryDiv(uint256 a, uint256 b)
694         internal
695         pure
696         returns (bool, uint256)
697     {
698         unchecked {
699             if (b == 0) return (false, 0);
700             return (true, a / b);
701         }
702     }
703 
704     function tryMod(uint256 a, uint256 b)
705         internal
706         pure
707         returns (bool, uint256)
708     {
709         unchecked {
710             if (b == 0) return (false, 0);
711             return (true, a % b);
712         }
713     }
714 
715     function add(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a + b;
717     }
718 
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a - b;
721     }
722 
723     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a * b;
725     }
726 
727     function div(uint256 a, uint256 b) internal pure returns (uint256) {
728         return a / b;
729     }
730 
731     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a % b;
733     }
734 
735     function sub(
736         uint256 a,
737         uint256 b,
738         string memory errorMessage
739     ) internal pure returns (uint256) {
740         unchecked {
741             require(b <= a, errorMessage);
742             return a - b;
743         }
744     }
745 
746     function div(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b > 0, errorMessage);
753             return a / b;
754         }
755     }
756 
757     function mod(
758         uint256 a,
759         uint256 b,
760         string memory errorMessage
761     ) internal pure returns (uint256) {
762         unchecked {
763             require(b > 0, errorMessage);
764             return a % b;
765         }
766     }
767 }
768 
769 /*
770  * @dev Contract starts here
771  */
772 
773 contract Zeus is ERC20, Ownable {
774     using SafeMath for uint256;
775 
776     IUniswapV2Router02 private uniswapV2Router;
777     address private uniswapV2Pair;
778 
779     bool private _swapping;
780     address public utility;
781 
782     address private _fundingWallet;
783     address private _LPAddress;
784     uint256 private swapAt = 25000 * (10 ** decimals());
785 
786     uint256 public maxTransactionAmountOnPurchase;
787     uint256 public maxTransactionAmountOnSale;
788     uint256 public maxWallet;
789 
790     bool public feesDisabled = false;
791     bool public tradingLive = false;
792 
793     uint256 private utilityFee = 1;
794     uint256 private _fundingFee = 7;
795     uint256 private _liquidityFee = 0;
796     uint256 private _BurningFee = 0;
797     uint256 private _tokensForFunding;
798     uint256 private _tokensForLiquidity;
799     uint256 private _tokensForUtility;
800     uint256 public buyFee;
801     uint256 public sellFee;
802     bool public buyStatus;
803     bool public sellStatus;
804 
805     uint256 public totalFees = _fundingFee + _liquidityFee + _BurningFee + utilityFee;
806 
807     // exlcude from fees and max transaction amount
808     mapping(address => bool) private _isExcludedFromFees;
809     mapping(address => bool) private _isExcludedMaxTransactionAmount;
810 
811     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
812     // could be subject to a maximum transfer amount
813     mapping(address => bool) private _automatedMarketMakerPairs;
814 
815     // to stop bot spam buys and sells on launch
816     mapping(address => uint256) private _holderLastTransferBlock;
817 
818     mapping (address => bool) public isBlackListed;
819 
820     constructor(string memory name, string memory symbol,uint256 _percent,address _utility,
821     address fundingWallet,address LPAddress, uint256 _buyFee, uint256 _sellFee) payable ERC20(name,symbol) {
822         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
823             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
824         );
825 
826         addSwapTreshold(_percent);
827         addUtility(_utility);
828         setTaxWallets(fundingWallet,LPAddress);
829         updateTradingFees(_buyFee,_sellFee);
830 
831         _isExcludedMaxTransactionAmount[address(_uniswapV2Router)] = true;
832         uniswapV2Router = _uniswapV2Router;
833 
834         uint256 totalSupply = 100000000 * 1e18;
835         sellStatus = true;
836         buyStatus = true;
837 
838         _fundingWallet = msg.sender;
839         _LPAddress = msg.sender;
840 
841         /*
842          * @dev Set the limits (maxBuy, maxSell, maxWallet).
843          */
844         updateLimits(1000001,1000001,1000001);
845 
846         // exclude from paying fees or having max transaction amount
847         excludeFromFees(owner(), true);
848         excludeFromFees(address(this), true);
849         excludeFromFees(address(0xdead), true);
850         excludeFromFees(_fundingWallet, true);
851         excludeFromFees(_LPAddress, true);
852 
853         _isExcludedMaxTransactionAmount[owner()] = true;
854         _isExcludedMaxTransactionAmount[address(this)] = true;
855         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
856         _isExcludedMaxTransactionAmount[_fundingWallet] = true;
857         _isExcludedMaxTransactionAmount[_LPAddress] = true;
858 
859         _mint(address(this), totalSupply);
860     }
861 
862 
863     function addSwapTreshold(uint256 _percent) public onlyOwner {
864         swapAt = (totalSupply() * _percent) / 1000000;
865         // Percentage of supply
866     }
867 
868 
869     /**
870      * @dev Once live, can never be switched off
871      */
872 
873      function addUtility(address _utility) public onlyOwner{
874          utility = _utility;
875      }
876 
877      function setTaxWallets(address fundingWallet,address LPAddress) public onlyOwner{
878         _fundingWallet = fundingWallet;
879         _LPAddress = LPAddress;
880      }
881 
882     function addInitialLP() external onlyOwner {
883         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
884                 address(this),
885                 uniswapV2Router.WETH()
886             );
887         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
888         _automatedMarketMakerPairs[address(uniswapV2Pair)] = true;
889 
890         _approve(address(this), address(uniswapV2Router), totalSupply());
891         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
892             address(this),
893             balanceOf(address(this)),
894             0,
895             0,
896             _LPAddress,
897             block.timestamp
898         );
899     }
900 
901     function addBlackList (address _evilUser) public onlyOwner {
902         isBlackListed[_evilUser] = true;
903     }
904 
905     function removeBlackList (address _clearedUser) public onlyOwner {
906         isBlackListed[_clearedUser] = false;
907     }
908 
909     function getBlacklisted(address _user) public view returns(bool){
910         return isBlackListed[_user];
911     }
912 
913     function enableTrading() external onlyOwner {
914         tradingLive = true;
915     }
916 
917     /**
918      * @dev Exclude from fee calculation
919      */
920     function excludeFromFees(address account, bool excluded)
921         public
922         onlyOwner
923     {
924         _isExcludedFromFees[account] = excluded;
925     }
926 
927     /**
928      * @dev Update token fees (max set to initial fee)
929      */
930 
931      function updateTradingFees(uint256 _buyFee,uint256 _sellFee) public onlyOwner {
932          require(_buyFee <= 10 && _sellFee <= 100, "Too much fee");
933         buyFee = _buyFee;
934         sellFee = _sellFee;
935      }
936 
937     function updateFees(
938         uint256 fundingFee,
939         uint256 liquidityFee,
940         uint256 BurningFee,
941         uint256 utilityFees
942     ) public onlyOwner {
943         require(fundingFee + liquidityFee + BurningFee <= 10);
944         require(utilityFees < 5);
945         utilityFee = utilityFees;
946         _fundingFee = fundingFee;
947         _liquidityFee = liquidityFee;
948         _BurningFee = BurningFee;
949         totalFees = fundingFee + liquidityFee + BurningFee + utilityFees;
950     }
951 
952     function updateLimits(
953         uint256 buyLimit,
954         uint256 sellLimit,
955         uint256 _maxWallet
956     ) public onlyOwner {
957         maxTransactionAmountOnPurchase = buyLimit * (10**decimals());
958         maxTransactionAmountOnSale = sellLimit * (10**decimals());
959         maxWallet = _maxWallet * (10**decimals());
960     }
961 
962     function removeLimits() public onlyOwner {
963         maxTransactionAmountOnPurchase = (2**256) - 1;
964         maxTransactionAmountOnSale = (2**256) - 1;
965         maxWallet = (2**256) - 1;
966     }
967 
968     function tradingStatus(bool buy, bool sell) public onlyOwner{
969         buyStatus = buy;
970         sellStatus = sell;
971     }
972 
973     /**
974      * @dev Enable and disable backend fees
975      */
976     function setFeeState(bool state) external onlyOwner {
977         feesDisabled = state;
978     }
979 
980     /**
981      * @dev Update wallet that receives fees and newly added LP
982      */
983     function updateTeamWallet(address fundingWalletAddr, address LPWalletAddr) external onlyOwner {
984         _fundingWallet = fundingWalletAddr;
985         _LPAddress = LPWalletAddr;
986     }
987 
988     /**
989      * @dev Check if an address is excluded from the fee calculation
990      */
991     function isExcludedFromFees(address account) external view returns (bool) {
992         return _isExcludedFromFees[account];
993     }
994 
995     function _transfer(
996         address from,
997         address to,
998         uint256 amount
999     ) internal override {
1000         require(from != address(0), "ERC20: transfer from the zero address");
1001         require(to != address(0), "ERC20: transfer to the zero address");
1002         require(!isBlackListed[from], "Sender Blacklisted");
1003         require(!isBlackListed[to], "Receiver Blacklisted");
1004 
1005         if (amount == 0) {
1006             super._transfer(from, to, 0);
1007             return;
1008         }
1009 
1010         if (
1011             from != owner() &&
1012             to != owner() &&
1013             to != address(0) &&
1014             to != address(0xdead) &&
1015             !_swapping
1016         ) {
1017             if (!tradingLive)
1018                 require(
1019                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1020                     "_transfer:: Trading is not active."
1021                 );
1022             // on buy
1023             if (
1024                 _automatedMarketMakerPairs[from] &&
1025                 !_isExcludedMaxTransactionAmount[to]
1026             ) {
1027                 require(
1028                     amount <= maxTransactionAmountOnPurchase,
1029                     "_transfer:: Buy transfer amount exceeds the maxTransactionAmount."
1030                 );
1031                 require(
1032                     amount + balanceOf(to) <= maxWallet,
1033                     "_transfer:: Max wallet exceeded"
1034                 );
1035             }
1036             // on sell
1037             else if (
1038                 _automatedMarketMakerPairs[to] &&
1039                 !_isExcludedMaxTransactionAmount[from]
1040             ) {
1041                 require(
1042                     amount <= maxTransactionAmountOnSale,
1043                     "_transfer:: Sell transfer amount exceeds the maxTransactionAmount."
1044                 );
1045             } else if (!_isExcludedMaxTransactionAmount[to]) {
1046                 require(
1047                     amount + balanceOf(to) <= maxWallet,
1048                     "_transfer:: Max wallet exceeded"
1049                 );
1050             }
1051         }
1052 
1053         bool CanISwap = balanceOf(address(this)) >= swapAt;
1054 
1055         if (
1056             CanISwap &&
1057             !_swapping &&
1058             !_automatedMarketMakerPairs[from] &&
1059             !_isExcludedFromFees[from] &&
1060             !_isExcludedFromFees[to]
1061         ) {
1062             _swapping = true;
1063 
1064             swapBack();
1065 
1066             _swapping = false;
1067         }
1068 
1069         bool takeFee = !_swapping;
1070 
1071         // if any addy belongs to _isExcludedFromFee or isn't a swap then remove the fee
1072         if (
1073             feesDisabled ||
1074             _isExcludedFromFees[from] ||
1075             _isExcludedFromFees[to] ||
1076             (!_automatedMarketMakerPairs[from] &&
1077                 !_automatedMarketMakerPairs[to])
1078         ) takeFee = false;
1079 
1080         uint256 fees = 0;
1081         if (takeFee) {
1082             uint256 feePercent;
1083             if(to == uniswapV2Pair){
1084                 require(sellStatus,"Sell status is closed");
1085                 feePercent = sellFee;
1086             }else if(from == uniswapV2Pair){
1087                 require(buyStatus,"Buy status is closed");
1088                 feePercent = buyFee;
1089             }
1090             fees = amount.mul(feePercent).div(100);
1091 
1092             _tokensForLiquidity += (fees.mul(_liquidityFee)).div(totalFees);
1093             _tokensForFunding += (fees.mul(_fundingFee)).div(totalFees);
1094             uint256 _tokensForBurning = (fees.mul(_BurningFee)).div(totalFees);
1095             _burn(address(this), _tokensForBurning);
1096             _tokensForUtility += (fees.mul(utilityFee).div(totalFees));
1097 
1098             if (fees > 0) {
1099                 super._transfer(from, address(this), fees);
1100             }
1101 
1102             amount -= fees;
1103         }
1104 
1105         super._transfer(from, to, amount);
1106     }
1107 
1108     function _swapTokensForETH(uint256 tokenAmount) internal {
1109         if(tokenAmount != 0){
1110         address[] memory path = new address[](2);
1111         path[0] = address(this);
1112         path[1] = uniswapV2Router.WETH();
1113 
1114         _approve(address(this), address(uniswapV2Router), tokenAmount);
1115 
1116         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1117             tokenAmount,
1118             0,
1119             path,
1120             address(this),
1121             block.timestamp
1122         );
1123         }
1124     }
1125 
1126     function _swapETHforTokens(uint256 _value) internal {
1127         if(_value != 0){
1128         address[] memory path = new address[](2);
1129         path[0] = uniswapV2Router.WETH();
1130         path[1] = utility;
1131 
1132         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: _value}(
1133             0,
1134             path,
1135             address(this),
1136             block.timestamp
1137         );
1138 
1139         uint256 output = IERC20(utility).balanceOf(address(this));
1140         address dead = 0x000000000000000000000000000000000000dEaD;
1141         IERC20(utility).transfer(dead,output);
1142         }
1143     }
1144 
1145     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1146         _approve(address(this), address(uniswapV2Router), tokenAmount);
1147 
1148         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1149             address(this),
1150             tokenAmount,
1151             0,
1152             0,
1153             _LPAddress,
1154             block.timestamp
1155         );
1156     }
1157 
1158     function swapBack() public {
1159         uint256 contractBalance = balanceOf(address(this));
1160 
1161         if (contractBalance == 0) return;
1162 
1163         uint256 liquidityTokens = _tokensForLiquidity / 2;
1164 
1165         _swapTokensForETH(_tokensForFunding);
1166 
1167         payable(_fundingWallet).transfer(address(this).balance);
1168 
1169         _swapTokensForETH(liquidityTokens);
1170 
1171         uint256 ethForLiquidity = address(this).balance;
1172 
1173         uint256 remainingBalance = balanceOf(address(this));
1174 
1175         if(ethForLiquidity > 0 && remainingBalance > 0){
1176         _addLiquidity(remainingBalance, ethForLiquidity);
1177         }
1178 
1179         _swapTokensForETH(_tokensForUtility);
1180 
1181         uint256 swapValue = address(this).balance;
1182 
1183         _swapETHforTokens(swapValue);
1184 
1185 
1186         _tokensForFunding = 0;
1187         _tokensForLiquidity = 0;
1188         _tokensForUtility = 0;
1189     }
1190 
1191     /**
1192      * @dev Transfer funds stuck in contract
1193      */
1194     function burnSupply(address to, uint256 amountToTransfer)
1195         external
1196         onlyOwner
1197     {
1198      //   
1199         _transfer(address(this), to, amountToTransfer);
1200     }
1201 
1202     /**
1203      * @dev Transfer funds stuck in contract
1204      */
1205     function withdrawContractFunds(address to, uint256 amountToTransfer)
1206         external
1207         onlyOwner
1208     {
1209         payable(to).transfer(amountToTransfer);
1210     }
1211 
1212     /**
1213      * @dev In case swap wont do it and sells/buys might be blocked
1214      */
1215     function forceSwap() external onlyOwner {
1216         _swapTokensForETH(balanceOf(address(this)));
1217     }
1218 
1219     receive() external payable {}
1220 }