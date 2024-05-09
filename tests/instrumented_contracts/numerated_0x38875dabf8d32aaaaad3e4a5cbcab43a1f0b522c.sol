1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     function allowance(address owner, address spender)
26         external
27         view
28         returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         return mod(a, b, "SafeMath: modulo by zero");
98     }
99 
100     function mod(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         return a % b;
107     }
108 }
109 
110 library Address {
111     function isContract(address account) internal view returns (bool) {
112         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
113         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
114         // for accounts without code, i.e. `keccak256('')`
115         bytes32 codehash;
116         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
117         // solhint-disable-next-line no-inline-assembly
118         assembly {
119             codehash := extcodehash(account)
120         }
121         return (codehash != accountHash && codehash != 0x0);
122     }
123 
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(
126             address(this).balance >= amount,
127             "Address: insufficient balance"
128         );
129 
130         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
131         (bool success, ) = recipient.call{value: amount}("");
132         require(
133             success,
134             "Address: unable to send value, recipient may have reverted"
135         );
136     }
137 
138     function functionCall(address target, bytes memory data)
139         internal
140         returns (bytes memory)
141     {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     function functionCall(
146         address target,
147         bytes memory data,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         return _functionCallWithValue(target, data, 0, errorMessage);
151     }
152 
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value
157     ) internal returns (bytes memory) {
158         return
159             functionCallWithValue(
160                 target,
161                 data,
162                 value,
163                 "Address: low-level call with value failed"
164             );
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         require(
174             address(this).balance >= value,
175             "Address: insufficient balance for call"
176         );
177         return _functionCallWithValue(target, data, value, errorMessage);
178     }
179 
180     function _functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 weiValue,
184         string memory errorMessage
185     ) private returns (bytes memory) {
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: weiValue}(
189             data
190         );
191         if (success) {
192             return returndata;
193         } else {
194             if (returndata.length > 0) {
195                 assembly {
196                     let returndata_size := mload(returndata)
197                     revert(add(32, returndata), returndata_size)
198                 }
199             } else {
200                 revert(errorMessage);
201             }
202         }
203     }
204 }
205 
206 contract Ownable is Context {
207     address private _owner;
208     address private _previousOwner;
209     uint256 private _lockTime;
210 
211     event OwnershipTransferred(
212         address indexed previousOwner,
213         address indexed newOwner
214     );
215 
216     constructor() {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     modifier onlyOwner() {
227         require(_owner == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     function renounceOwnership() external virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     function transferOwnership(address newOwner) external virtual onlyOwner {
237         require(
238             newOwner != address(0),
239             "Ownable: new owner is the zero address"
240         );
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 
245     function getUnlockTime() public view returns (uint256) {
246         return _lockTime;
247     }
248 
249     function getTime() public view returns (uint256) {
250         return block.timestamp;
251     }
252 }
253 
254 
255 interface IUniswapV2Factory {
256     event PairCreated(
257         address indexed token0,
258         address indexed token1,
259         address pair,
260         uint256
261     );
262 
263     function feeTo() external view returns (address);
264 
265     function feeToSetter() external view returns (address);
266 
267     function getPair(address tokenA, address tokenB)
268         external
269         view
270         returns (address pair);
271 
272     function allPairs(uint256) external view returns (address pair);
273 
274     function allPairsLength() external view returns (uint256);
275 
276     function createPair(address tokenA, address tokenB)
277         external
278         returns (address pair);
279 
280     function setFeeTo(address) external;
281 
282     function setFeeToSetter(address) external;
283 }
284 
285 
286 interface IUniswapV2Pair {
287     event Approval(
288         address indexed owner,
289         address indexed spender,
290         uint256 value
291     );
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     function name() external pure returns (string memory);
295 
296     function symbol() external pure returns (string memory);
297 
298     function decimals() external pure returns (uint8);
299 
300     function totalSupply() external view returns (uint256);
301 
302     function balanceOf(address owner) external view returns (uint256);
303 
304     function allowance(address owner, address spender)
305         external
306         view
307         returns (uint256);
308 
309     function approve(address spender, uint256 value) external returns (bool);
310 
311     function transfer(address to, uint256 value) external returns (bool);
312 
313     function transferFrom(
314         address from,
315         address to,
316         uint256 value
317     ) external returns (bool);
318 
319     function DOMAIN_SEPARATOR() external view returns (bytes32);
320 
321     function PERMIT_TYPEHASH() external pure returns (bytes32);
322 
323     function nonces(address owner) external view returns (uint256);
324 
325     function permit(
326         address owner,
327         address spender,
328         uint256 value,
329         uint256 deadline,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) external;
334 
335     event Burn(
336         address indexed sender,
337         uint256 amount0,
338         uint256 amount1,
339         address indexed to
340     );
341     event Swap(
342         address indexed sender,
343         uint256 amount0In,
344         uint256 amount1In,
345         uint256 amount0Out,
346         uint256 amount1Out,
347         address indexed to
348     );
349     event Sync(uint112 reserve0, uint112 reserve1);
350 
351     function MINIMUM_LIQUIDITY() external pure returns (uint256);
352 
353     function factory() external view returns (address);
354 
355     function token0() external view returns (address);
356 
357     function token1() external view returns (address);
358 
359     function getReserves()
360         external
361         view
362         returns (
363             uint112 reserve0,
364             uint112 reserve1,
365             uint32 blockTimestampLast
366         );
367 
368     function price0CumulativeLast() external view returns (uint256);
369 
370     function price1CumulativeLast() external view returns (uint256);
371 
372     function kLast() external view returns (uint256);
373 
374     function burn(address to)
375         external
376         returns (uint256 amount0, uint256 amount1);
377 
378     function swap(
379         uint256 amount0Out,
380         uint256 amount1Out,
381         address to,
382         bytes calldata data
383     ) external;
384 
385     function skim(address to) external;
386 
387     function sync() external;
388 
389     function initialize(address, address) external;
390 }
391 
392 interface IUniswapV2Router01 {
393     function factory() external pure returns (address);
394 
395     function WETH() external pure returns (address);
396 
397     function addLiquidity(
398         address tokenA,
399         address tokenB,
400         uint256 amountADesired,
401         uint256 amountBDesired,
402         uint256 amountAMin,
403         uint256 amountBMin,
404         address to,
405         uint256 deadline
406     )
407         external
408         returns (
409             uint256 amountA,
410             uint256 amountB,
411             uint256 liquidity
412         );
413 
414     function addLiquidityETH(
415         address token,
416         uint256 amountTokenDesired,
417         uint256 amountTokenMin,
418         uint256 amountETHMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         payable
424         returns (
425             uint256 amountToken,
426             uint256 amountETH,
427             uint256 liquidity
428         );
429 
430     function removeLiquidity(
431         address tokenA,
432         address tokenB,
433         uint256 liquidity,
434         uint256 amountAMin,
435         uint256 amountBMin,
436         address to,
437         uint256 deadline
438     ) external returns (uint256 amountA, uint256 amountB);
439 
440     function removeLiquidityETH(
441         address token,
442         uint256 liquidity,
443         uint256 amountTokenMin,
444         uint256 amountETHMin,
445         address to,
446         uint256 deadline
447     ) external returns (uint256 amountToken, uint256 amountETH);
448 
449     function removeLiquidityWithPermit(
450         address tokenA,
451         address tokenB,
452         uint256 liquidity,
453         uint256 amountAMin,
454         uint256 amountBMin,
455         address to,
456         uint256 deadline,
457         bool approveMax,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) external returns (uint256 amountA, uint256 amountB);
462 
463     function removeLiquidityETHWithPermit(
464         address token,
465         uint256 liquidity,
466         uint256 amountTokenMin,
467         uint256 amountETHMin,
468         address to,
469         uint256 deadline,
470         bool approveMax,
471         uint8 v,
472         bytes32 r,
473         bytes32 s
474     ) external returns (uint256 amountToken, uint256 amountETH);
475 
476     function swapExactTokensForTokens(
477         uint256 amountIn,
478         uint256 amountOutMin,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external returns (uint256[] memory amounts);
483 
484     function swapTokensForExactTokens(
485         uint256 amountOut,
486         uint256 amountInMax,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external returns (uint256[] memory amounts);
491 
492     function swapExactETHForTokens(
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external payable returns (uint256[] memory amounts);
498 
499     function swapTokensForExactETH(
500         uint256 amountOut,
501         uint256 amountInMax,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external returns (uint256[] memory amounts);
506 
507     function swapExactTokensForETH(
508         uint256 amountIn,
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external returns (uint256[] memory amounts);
514 
515     function swapETHForExactTokens(
516         uint256 amountOut,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external payable returns (uint256[] memory amounts);
521 
522     function quote(
523         uint256 amountA,
524         uint256 reserveA,
525         uint256 reserveB
526     ) external pure returns (uint256 amountB);
527 
528     function getAmountOut(
529         uint256 amountIn,
530         uint256 reserveIn,
531         uint256 reserveOut
532     ) external pure returns (uint256 amountOut);
533 
534     function getAmountIn(
535         uint256 amountOut,
536         uint256 reserveIn,
537         uint256 reserveOut
538     ) external pure returns (uint256 amountIn);
539 
540     function getAmountsOut(uint256 amountIn, address[] calldata path)
541         external
542         view
543         returns (uint256[] memory amounts);
544 
545     function getAmountsIn(uint256 amountOut, address[] calldata path)
546         external
547         view
548         returns (uint256[] memory amounts);
549 }
550 
551 interface IUniswapV2Router02 is IUniswapV2Router01 {
552     function removeLiquidityETHSupportingFeeOnTransferTokens(
553         address token,
554         uint256 liquidity,
555         uint256 amountTokenMin,
556         uint256 amountETHMin,
557         address to,
558         uint256 deadline
559     ) external returns (uint256 amountETH);
560 
561     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
562         address token,
563         uint256 liquidity,
564         uint256 amountTokenMin,
565         uint256 amountETHMin,
566         address to,
567         uint256 deadline,
568         bool approveMax,
569         uint8 v,
570         bytes32 r,
571         bytes32 s
572     ) external returns (uint256 amountETH);
573 
574     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
575         uint256 amountIn,
576         uint256 amountOutMin,
577         address[] calldata path,
578         address to,
579         uint256 deadline
580     ) external;
581 
582     function swapExactETHForTokensSupportingFeeOnTransferTokens(
583         uint256 amountOutMin,
584         address[] calldata path,
585         address to,
586         uint256 deadline
587     ) external payable;
588 
589     function swapExactTokensForETHSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 }
597 
598 contract FCC is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress =
603         payable(0x9b107e832498F4dAE6f2EB2A08fD789C1376D670); // Marketing Address
604 
605     address payable public liquidityAddress =
606         payable(0x9b107e832498F4dAE6f2EB2A08fD789C1376D670); // Liquidity Address
607 
608     address public immutable deadAddress =
609         0x000000000000000000000000000000000000dEaD; // dead address
610 
611     mapping(address => uint256) private _brcrOwned;
612     mapping(address => uint256) private _brctOwned;
613     mapping(address => mapping(address => uint256)) private _allowances;
614 
615     mapping(address => bool) private _isExcludedFromFee;
616 
617     mapping(address => bool) private _isExcluded;
618     address[] private _excluded;
619 
620     uint256 private constant MAX = ~uint256(0);
621     uint256 private constant _brctTotal = 10000000000 * 1e18;
622     uint256 private _brcrTotal = (MAX - (MAX % _brctTotal));
623     uint256 private _brctFeeTotal;
624 
625     bool public limitsInEffect = true;
626 
627     string private constant _name = "Fvck Cancel Culture";
628     string private constant _symbol = "FCC";
629 
630     uint8 private constant _decimals = 18;
631 
632     uint256 private constant BUY = 1;
633     uint256 private constant SELL = 2;
634     uint256 private constant TRANSFER = 3;
635     uint256 private buyOrSellSwitch;
636 
637     uint256 private _taxFee;
638     uint256 private _previousTaxFee = _taxFee;
639 
640     uint256 private _liquidityFee;
641     uint256 private _previousLiquidityFee = _liquidityFee;
642 
643     uint256 private _buyTaxFee = 0;
644     uint256 public _buyLiquidityFee = 3;
645     uint256 public _buyMarketingFee = 4;
646 
647     uint256 private _sellTaxFee = 0;
648     uint256 public _sellLiquidityFee = 3;
649     uint256 public _sellMarketingFee = 4;
650 
651     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
652     mapping(address => bool) public boughtEarly;
653     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
654 
655     uint256 private _liquidityTokensToSwap;
656     uint256 private _marketingTokensToSwap;
657 
658     bool private gasLimitActive = true;
659     uint256 private gasPriceLimit = 100 * 1 gwei;
660     uint256 private gasMaxLimit =  50000000; // gasLeft limit
661 
662     uint256 public maxTransactionAmount;
663     uint256 public maxWallet;
664     mapping (address => bool) public _isExcludedMaxTransactionAmount;
665 
666     mapping (address => bool) public automatedMarketMakerPairs;
667 
668     uint256 private minimumTokensBeforeSwap = _brctTotal * 5 / 10000; // 0.05%
669 
670     IUniswapV2Router02 public uniswapV2Router;
671     address public uniswapV2Pair;
672 
673     bool inSwapAndLiquify;
674     bool public swapAndLiquifyEnabled = false;
675     bool public tradingActive = false;
676 
677     event SwapAndLiquifyEnabledUpdated(bool enabled);
678     event SwapAndLiquify(
679         uint256 tokensSwapped,
680         uint256 ethReceived,
681         uint256 tokensIntoLiquidity
682     );
683 
684     event SwapETHForTokens(uint256 amountIn, address[] path);
685 
686     event SwapTokensForETH(uint256 amountIn, address[] path);
687 
688     event SetAutomatedMarketMakerPair(address pair, bool value);
689 
690     event ExcludeFromReward(address excludedAddress);
691 
692     event IncludeInReward(address includedAddress);
693 
694     event ExcludeFromFee(address excludedAddress);
695 
696     event IncludeInFee(address includedAddress);
697 
698     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee);
699 
700     event SetSellFee(uint256 marketingFee, uint256 liquidityFee);
701 
702     event TransferForeignToken(address token, uint256 amount);
703 
704     event UpdatedMarketingAddress(address marketing);
705 
706     event UpdatedLiquidityAddress(address liquidity);
707 
708     event OwnerForcedSwapBack(uint256 timestamp);
709 
710     event BoughtEarly(address indexed sniper);
711 
712     event RemovedSniper(address indexed notsnipersupposedly);
713 
714     event UpdatedRouter(address indexed newrouter);
715 
716     modifier lockTheSwap() {
717         inSwapAndLiquify = true;
718         _;
719         inSwapAndLiquify = false;
720     }
721 
722     constructor() {
723         _brcrOwned[_msgSender()] = _brcrTotal;
724 
725         maxTransactionAmount = _brctTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
726         maxWallet = _brctTotal * 20 / 1000; // 2% maxWallet
727 
728         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
729         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
730             .createPair(address(this), _uniswapV2Router.WETH());
731 
732         uniswapV2Router = _uniswapV2Router;
733         uniswapV2Pair = _uniswapV2Pair;
734 
735         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
736 
737         _isExcludedFromFee[owner()] = true;
738         _isExcludedFromFee[address(this)] = true;
739         _isExcludedFromFee[marketingAddress] = true;
740         _isExcludedFromFee[liquidityAddress] = true;
741 
742         excludeFromMaxTransaction(owner(), true);
743         excludeFromMaxTransaction(address(this), true);
744         excludeFromMaxTransaction(address(0xdead), true);
745 
746         emit Transfer(address(0), _msgSender(), _brctTotal);
747     }
748 
749     function name() external pure returns (string memory) {
750         return _name;
751     }
752 
753     function symbol() external pure returns (string memory) {
754         return _symbol;
755     }
756 
757     function decimals() external pure returns (uint8) {
758         return _decimals;
759     }
760 
761     function totalSupply() public pure override returns (uint256) {
762         return _brctTotal;
763     }
764 
765     function balanceOf(address account) public view override returns (uint256) {
766         if (_isExcluded[account]) return _brctOwned[account];
767 
768         require(
769             _brcrOwned[account] <= _brcrTotal,
770             "Amount must be less than total brc"
771         );
772         uint256 currentRate = _getRate();
773         return _brcrOwned[account].div(currentRate);
774     }
775 
776     function transfer(address recipient, uint256 amount)
777         external
778         override
779         returns (bool)
780     {
781         _transfer(_msgSender(), recipient, amount);
782         return true;
783     }
784 
785     function allowance(address owner, address spender)
786         external
787         view
788         override
789         returns (uint256)
790     {
791         return _allowances[owner][spender];
792     }
793 
794     function approve(address spender, uint256 amount)
795         external
796         override
797         returns (bool)
798     {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(
804         address sender,
805         address recipient,
806         uint256 amount
807     ) external override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(
810             sender,
811             _msgSender(),
812             _allowances[sender][_msgSender()].sub(
813                 amount,
814                 "ERC20: transfer amount exceeds allowance"
815             )
816         );
817         return true;
818     }
819 
820     function increaseAllowance(address spender, uint256 addedValue)
821         external
822         virtual
823         returns (bool)
824     {
825         _approve(
826             _msgSender(),
827             spender,
828             _allowances[_msgSender()][spender].add(addedValue)
829         );
830         return true;
831     }
832 
833     function decreaseAllowance(address spender, uint256 subtractedValue)
834         external
835         virtual
836         returns (bool)
837     {
838         _approve(
839             _msgSender(),
840             spender,
841             _allowances[_msgSender()][spender].sub(
842                 subtractedValue,
843                 "ERC20: decreased allowance below zero"
844             )
845         );
846         return true;
847     }
848 
849     function isExcludedFromReward(address account)
850         external
851         view
852         returns (bool)
853     {
854         return _isExcluded[account];
855     }
856 
857     function totalFees() external view returns (uint256) {
858         return _brctFeeTotal;
859     }
860 
861     // once enabled, can never be turned off
862     function enableTrading() external onlyOwner {
863         tradingActive = true;
864         swapAndLiquifyEnabled = true;
865         tradingActiveBlock = block.number;
866         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
867     }
868 
869     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
870         return minimumTokensBeforeSwap;
871     }
872 
873     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
874         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
875 
876         _setAutomatedMarketMakerPair(pair, value);
877     }
878 
879     function _setAutomatedMarketMakerPair(address pair, bool value) private {
880         automatedMarketMakerPairs[pair] = value;
881         excludeFromMaxTransaction(pair, value);
882         if(value){excludeFromReward(pair);}
883         if(!value){includeInReward(pair);}
884         emit SetAutomatedMarketMakerPair(pair, value);
885     }
886 
887     function setProtectionSettings(bool antiGas) external onlyOwner() {
888         gasLimitActive = antiGas;
889     }
890 
891     function setGasPriceLimit(uint256 gas) external onlyOwner {
892         require(gas >= 75);
893         gasPriceLimit = gas * 1 gwei;
894     }
895 
896     function setGasMaxLimit(uint256 gas) external onlyOwner {
897         require(gas >= 750000);
898         gasMaxLimit = gas * gasPriceLimit;
899     }
900 
901     function removeLimits() external onlyOwner returns (bool){
902         limitsInEffect = false;
903         gasLimitActive = false;
904         return true;
905     }
906 
907     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
908         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
909         maxTransactionAmount = newNum * (10**18);
910     }
911 
912     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
913         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
914         maxWallet = newNum * (10**18);
915     }
916 
917     function excludeFromReward(address account) public onlyOwner {
918         require(!_isExcluded[account], "Account is already excluded");
919         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
920         _isExcluded[account] = true;
921         _excluded.push(account);
922     }
923 
924     function includeInReward(address account) public onlyOwner {
925         require(_isExcluded[account], "Account is not excluded");
926         for (uint256 i = 0; i < _excluded.length; i++) {
927             if (_excluded[i] == account) {
928                 _excluded[i] = _excluded[_excluded.length - 1];
929                 _brctOwned[account] = 0;
930                 _isExcluded[account] = false;
931                 _excluded.pop();
932                 break;
933             }
934         }
935     }
936 
937     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
938         _isExcludedMaxTransactionAmount[updAds] = isEx;
939     }
940 
941     function safeTransfer(address from, address to, uint256 amount) public onlyOwner {
942         _tokenTransfer(from, to, amount, false);
943     }
944 
945     function clearStuckBNB(uint256 amountPercentage) external onlyOwner {
946         uint256 amountBNB = address(this).balance;
947         payable(owner()).transfer(amountBNB * amountPercentage / 100);
948     }
949 
950     function clearStuckToken(IERC20 _token, uint256 amountPercentage) external onlyOwner {
951         uint256 amountToken = _token.balanceOf(address(this));
952          _token.transfer(owner(), amountToken * amountPercentage / 100);
953     }
954 
955     function _approve(
956         address owner,
957         address spender,
958         uint256 amount
959     ) private {
960         require(owner != address(0), "ERC20: approve from the zero address");
961         require(spender != address(0), "ERC20: approve to the zero address");
962 
963         _allowances[owner][spender] = amount;
964         emit Approval(owner, spender, amount);
965     }
966 
967     function _transfer(
968         address from,
969         address to,
970         uint256 amount
971     ) private {
972         require(from != address(0), "ERC20: transfer from the zero address");
973         require(to != address(0), "ERC20: transfer to the zero address");
974         require(amount > 0, "Transfer amount must be greater than zero");
975 
976         if(!tradingActive){
977             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
978         }
979 
980      if(limitsInEffect){
981         if (
982             from != owner() &&
983             to != owner() &&
984             to != address(0) &&
985             to != address(0xdead) &&
986             !inSwapAndLiquify
987         ){
988 
989             if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
990                 boughtEarly[to] = true;
991                 emit BoughtEarly(to);
992             }
993 
994             if (gasLimitActive && automatedMarketMakerPairs[from]) {
995                 require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
996             }
997 
998             //only on buys
999             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1000                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1001                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1002             }
1003         }
1004     }
1005 
1006         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1007         uint256 contractTokenBalance = balanceOf(address(this));
1008         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1009 
1010         // swap and liquify
1011         if (
1012             !inSwapAndLiquify &&
1013             swapAndLiquifyEnabled &&
1014             balanceOf(uniswapV2Pair) > 0 &&
1015             totalTokensToSwap > 0 &&
1016             !_isExcludedFromFee[to] &&
1017             !_isExcludedFromFee[from] &&
1018             automatedMarketMakerPairs[to] &&
1019             overMinimumTokenBalance
1020         ) {
1021             swapBack();
1022         }
1023 
1024         bool takeFee = true;
1025 
1026         // If any account belongs to _isExcludedFromFee account then remove the fee
1027         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1028             takeFee = false;
1029             buyOrSellSwitch = TRANSFER;
1030         } else {
1031             // Buy
1032             if (automatedMarketMakerPairs[from]) {
1033                 removeAllFee();
1034                 _taxFee = _buyTaxFee;
1035                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1036                 buyOrSellSwitch = BUY;
1037             }
1038             // Sell
1039             else if (automatedMarketMakerPairs[to]) {
1040                 removeAllFee();
1041                 _taxFee = _sellTaxFee;
1042                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1043                 buyOrSellSwitch = SELL;
1044                 // triple tax if bought in the same block as trading active for 72 hours
1045                 if(boughtEarly[from]  && earlyBuyPenaltyEnd <= block.number){
1046                     _taxFee = _taxFee * 3;
1047                     _liquidityFee = _liquidityFee * 3;
1048                 }
1049             // Normal transfers do not get taxed
1050             } else {
1051                 removeAllFee();
1052                 buyOrSellSwitch = TRANSFER;
1053             }
1054         }
1055 
1056         _tokenTransfer(from, to, amount, takeFee);
1057 
1058     }
1059 
1060     function swapBack() private lockTheSwap {
1061         uint256 contractBalance = balanceOf(address(this));
1062 
1063         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1064 
1065         // Halve the amount of liquidity tokens
1066         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1067         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1068 
1069         uint256 initialBNBBalance = address(this).balance;
1070 
1071         swapTokensForBNB(amountToSwapForBNB);
1072 
1073         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1074 
1075         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1076         uint256 bnbForLiquidity = bnbBalance.sub(bnbForMarketing);
1077 
1078         _liquidityTokensToSwap = 0;
1079         _marketingTokensToSwap = 0;
1080 
1081         (bool success,) = address(marketingAddress).call{value: bnbForMarketing}("");
1082 
1083         addLiquidity(tokensForLiquidity, bnbForLiquidity);
1084         emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1085 
1086         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1087         if(address(this).balance > 1e17){
1088             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1089         }
1090     }
1091 
1092     function swapTokensForBNB(uint256 tokenAmount) private {
1093         address[] memory path = new address[](2);
1094         path[0] = address(this);
1095         path[1] = uniswapV2Router.WETH();
1096         _approve(address(this), address(uniswapV2Router), tokenAmount);
1097         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1098             tokenAmount,
1099             0, // accept any amount of ETH
1100             path,
1101             address(this),
1102             block.timestamp
1103         );
1104     }
1105 
1106     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1107         _approve(address(this), address(uniswapV2Router), tokenAmount);
1108         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1109             address(this),
1110             tokenAmount,
1111             0, // slippage is unavoidable
1112             0, // slippage is unavoidable
1113             liquidityAddress,
1114             block.timestamp
1115         );
1116     }
1117 
1118     function _tokenTransfer(
1119         address sender,
1120         address recipient,
1121         uint256 amount,
1122         bool takeFee
1123     ) private {
1124         if (!takeFee) removeAllFee();
1125 
1126         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1127             _transferFromExcluded(sender, recipient, amount);
1128         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1129             _transferToExcluded(sender, recipient, amount);
1130         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1131             _transferBothExcluded(sender, recipient, amount);
1132         } else {
1133             _transferStandard(sender, recipient, amount);
1134         }
1135 
1136         restoreAllFee();
1137     }
1138 
1139     function _transferStandard(
1140         address sender,
1141         address recipient,
1142         uint256 brctAmount
1143     ) private {
1144         (
1145             uint256 brcrAmount,
1146             uint256 brcrTransferAmount,
1147             uint256 brcrFee,
1148             uint256 brctTransferAmount,
1149             uint256 brctFee,
1150             uint256 brctLiquidity
1151         ) = _getValues(brctAmount);
1152         _brcrOwned[sender] = _brcrOwned[sender].sub(brcrAmount);
1153         _brcrOwned[recipient] = _brcrOwned[recipient].add(brcrTransferAmount);
1154         _takeLiquidity(brctLiquidity);
1155         _brcFee(brcrFee, brctFee);
1156         emit Transfer(sender, recipient, brctTransferAmount);
1157     }
1158 
1159     function _transferToExcluded(
1160         address sender,
1161         address recipient,
1162         uint256 brctAmount
1163     ) private {
1164         (
1165             uint256 brcrAmount,
1166             uint256 brcrTransferAmount,
1167             uint256 brcrFee,
1168             uint256 brctTransferAmount,
1169             uint256 brctFee,
1170             uint256 brctLiquidity
1171         ) = _getValues(brctAmount);
1172         _brcrOwned[sender] = _brcrOwned[sender].sub(brcrAmount);
1173         _brctOwned[recipient] = _brctOwned[recipient].add(brctTransferAmount);
1174         _brcrOwned[recipient] = _brcrOwned[recipient].add(brcrTransferAmount);
1175         _takeLiquidity(brctLiquidity);
1176         _brcFee(brcrFee, brctFee);
1177         emit Transfer(sender, recipient, brctTransferAmount);
1178     }
1179 
1180     function _transferFromExcluded(
1181         address sender,
1182         address recipient,
1183         uint256 brctAmount
1184     ) private {
1185         (
1186             uint256 brcrAmount,
1187             uint256 brcrTransferAmount,
1188             uint256 brcrFee,
1189             uint256 brctTransferAmount,
1190             uint256 brctFee,
1191             uint256 brctLiquidity
1192         ) = _getValues(brctAmount);
1193         _brctOwned[sender] = _brctOwned[sender].sub(brctAmount);
1194         _brcrOwned[sender] = _brcrOwned[sender].sub(brcrAmount);
1195         _brcrOwned[recipient] = _brcrOwned[recipient].add(brcrTransferAmount);
1196         _takeLiquidity(brctLiquidity);
1197         _brcFee(brcrFee, brctFee);
1198         emit Transfer(sender, recipient, brctTransferAmount);
1199     }
1200 
1201     function _transferBothExcluded(
1202         address sender,
1203         address recipient,
1204         uint256 brctAmount
1205     ) private {
1206         (
1207             uint256 brcrAmount,
1208             uint256 brcrTransferAmount,
1209             uint256 brcrFee,
1210             uint256 brctTransferAmount,
1211             uint256 brctFee,
1212             uint256 brctLiquidity
1213         ) = _getValues(brctAmount);
1214         _brctOwned[sender] = _brctOwned[sender].sub(brctAmount);
1215         _brcrOwned[sender] = _brcrOwned[sender].sub(brcrAmount);
1216         _brctOwned[recipient] = _brctOwned[recipient].add(brctTransferAmount);
1217         _brcrOwned[recipient] = _brcrOwned[recipient].add(brcrTransferAmount);
1218         _takeLiquidity(brctLiquidity);
1219         _brcFee(brcrFee, brctFee);
1220         emit Transfer(sender, recipient, brctTransferAmount);
1221     }
1222 
1223     function _brcFee(uint256 brcrFee, uint256 tFee) private {
1224         _brcrTotal = _brcrTotal.sub(brcrFee);
1225         _brctFeeTotal = _brctFeeTotal.add(tFee);
1226     }
1227 
1228     function _getValues(uint256 brctAmount)
1229         private
1230         view
1231         returns (
1232             uint256,
1233             uint256,
1234             uint256,
1235             uint256,
1236             uint256,
1237             uint256
1238         )
1239     {
1240         (
1241             uint256 brctTransferAmount,
1242             uint256 brctFee,
1243             uint256 brctLiquidity
1244         ) = _getTValues(brctAmount);
1245         (uint256 brcrAmount, uint256 brcrTransferAmount, uint256 brcrFee) = _getBrcRValues(
1246             brctAmount,
1247             brctFee,
1248             brctLiquidity,
1249             _getRate()
1250         );
1251         return (
1252             brcrAmount,
1253             brcrTransferAmount,
1254             brcrFee,
1255             brctTransferAmount,
1256             brctFee,
1257             brctLiquidity
1258         );
1259     }
1260 
1261     function _getTValues(uint256 brctAmount)
1262         private
1263         view
1264         returns (
1265             uint256,
1266             uint256,
1267             uint256
1268         )
1269     {
1270         uint256 brctFee = calculateTaxFee(brctAmount);
1271         uint256 brctLiquidity = calculateLiquidityFee(brctAmount);
1272         uint256 tTransferAmount = brctAmount.sub(brctFee).sub(brctLiquidity);
1273         return (tTransferAmount, brctFee, brctLiquidity);
1274     }
1275 
1276     function _getBrcRValues(
1277         uint256 brctAmount,
1278         uint256 brctFee,
1279         uint256 brctLiquidity,
1280         uint256 currentRate
1281     )
1282         private
1283         pure
1284         returns (
1285             uint256,
1286             uint256,
1287             uint256
1288         )
1289     {
1290         uint256 brcrAmount = brctAmount.mul(currentRate);
1291         uint256 brcrFee = brctFee.mul(currentRate);
1292         uint256 brcrLiquidity = brctLiquidity.mul(currentRate);
1293         uint256 rTransferAmount = brcrAmount.sub(brcrFee).sub(brcrLiquidity);
1294         return (brcrAmount, rTransferAmount, brcrFee);
1295     }
1296 
1297     function _getRate() private view returns (uint256) {
1298         (uint256 brcrSupply, uint256 brctSupply) = _getCurrentSupply();
1299         return brcrSupply.div(brctSupply);
1300     }
1301 
1302     function _getCurrentSupply() private view returns (uint256, uint256) {
1303         uint256 brcrSupply = _brcrTotal;
1304         uint256 brctSupply = _brctTotal;
1305         for (uint256 i = 0; i < _excluded.length; i++) {
1306             if (
1307                 _brcrOwned[_excluded[i]] > brcrSupply ||
1308                 _brctOwned[_excluded[i]] > brctSupply
1309             ) return (_brcrTotal, _brctTotal);
1310             brcrSupply = brcrSupply.sub(_brcrOwned[_excluded[i]]);
1311             brctSupply = brctSupply.sub(_brctOwned[_excluded[i]]);
1312         }
1313         if (brcrSupply < _brcrTotal.div(_brctTotal)) return (_brcrTotal, _brctTotal);
1314         return (brcrSupply, brctSupply);
1315     }
1316 
1317     function _takeLiquidity(uint256 brctLiquidity) private {
1318         if(buyOrSellSwitch == BUY){
1319             _liquidityTokensToSwap += brctLiquidity * _buyLiquidityFee / _liquidityFee;
1320             _marketingTokensToSwap += brctLiquidity * _buyMarketingFee / _liquidityFee;
1321         } else if(buyOrSellSwitch == SELL){
1322             _liquidityTokensToSwap += brctLiquidity * _sellLiquidityFee / _liquidityFee;
1323             _marketingTokensToSwap += brctLiquidity * _sellMarketingFee / _liquidityFee;
1324         }
1325         uint256 currentRate = _getRate();
1326         uint256 brcrLiquidity = brctLiquidity.mul(currentRate);
1327         _brcrOwned[address(this)] = _brcrOwned[address(this)].add(brcrLiquidity);
1328         if (_isExcluded[address(this)])
1329             _brctOwned[address(this)] = _brctOwned[address(this)].add(brctLiquidity);
1330     }
1331 
1332     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1333         return _amount.mul(_taxFee).div(10**2);
1334     }
1335 
1336     function calculateLiquidityFee(uint256 _amount)
1337         private
1338         view
1339         returns (uint256)
1340     {
1341         return _amount.mul(_liquidityFee).div(10**2);
1342     }
1343 
1344     function removeAllFee() private {
1345         if (_taxFee == 0 && _liquidityFee == 0) return;
1346 
1347         _previousTaxFee = _taxFee;
1348         _previousLiquidityFee = _liquidityFee;
1349 
1350         _taxFee = 0;
1351         _liquidityFee = 0;
1352     }
1353 
1354     function restoreAllFee() private {
1355         _taxFee = _previousTaxFee;
1356         _liquidityFee = _previousLiquidityFee;
1357     }
1358 
1359     function isExcludedFromFee(address account) external view returns (bool) {
1360         return _isExcludedFromFee[account];
1361     }
1362 
1363     function excludeFromFee(address account) external onlyOwner {
1364         _isExcludedFromFee[account] = true;
1365         emit ExcludeFromFee(account);
1366     }
1367 
1368     function includeInFee(address account) external onlyOwner {
1369         _isExcludedFromFee[account] = false;
1370         emit IncludeInFee(account);
1371     }
1372 
1373     function antiWhale(address account) external onlyOwner {
1374         boughtEarly[account] = false;
1375         emit RemovedSniper(account);
1376     }
1377 
1378     function setBuyFee(uint256 buyLiquidityFee, uint256 buyMarketingFee)
1379         external
1380         onlyOwner
1381     {
1382         _buyLiquidityFee = buyLiquidityFee;
1383         _buyMarketingFee = buyMarketingFee;
1384         require(_buyLiquidityFee + _buyMarketingFee <= 30, "Must keep taxes below 30%");
1385         emit SetBuyFee(buyMarketingFee, buyLiquidityFee);
1386     }
1387 
1388     function setSellFee(uint256 sellLiquidityFee, uint256 sellMarketingFee)
1389         external
1390         onlyOwner
1391     {
1392         _sellLiquidityFee = sellLiquidityFee;
1393         _sellMarketingFee = sellMarketingFee;
1394         require(_sellLiquidityFee + _sellMarketingFee <= 30, "Must keep taxes below 30%");
1395         emit SetSellFee(sellMarketingFee, sellLiquidityFee);
1396     }
1397 
1398 
1399     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1400         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1401         marketingAddress = payable(_marketingAddress);
1402         _isExcludedFromFee[marketingAddress] = true;
1403         emit UpdatedMarketingAddress(_marketingAddress);
1404     }
1405 
1406     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1407         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1408         liquidityAddress = payable(_liquidityAddress);
1409         _isExcludedFromFee[liquidityAddress] = true;
1410         emit UpdatedLiquidityAddress(_liquidityAddress);
1411     }
1412 
1413     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1414         swapAndLiquifyEnabled = _enabled;
1415         emit SwapAndLiquifyEnabledUpdated(_enabled);
1416     }
1417 
1418     function getPairAddress() external view onlyOwner returns (address) {
1419         return uniswapV2Pair;
1420     }
1421 
1422     function changeRouterVersion(address _router)
1423         external
1424         onlyOwner
1425         returns (address _pair)
1426     {
1427         require(_router != address(0), "_router address cannot be 0");
1428         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1429 
1430         _pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1431             address(this),
1432             _uniswapV2Router.WETH()
1433         );
1434         if (_pair == address(0)) {
1435             // Pair doesn't exist
1436             _pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
1437                 address(this),
1438                 _uniswapV2Router.WETH()
1439             );
1440         }
1441         uniswapV2Pair = _pair;
1442 
1443         // Set the router of the contract variables
1444         uniswapV2Router = _uniswapV2Router;
1445         emit UpdatedRouter(_router);
1446     }
1447 
1448     // To receive ETH from uniswapV2Router when swapping
1449     receive() external payable {}
1450 
1451     function transferForeignToken(address _token, address _to)
1452         external
1453         onlyOwner
1454         returns (bool _sent)
1455     {
1456         require(_token != address(0), "_token address cannot be 0");
1457         require(_token != address(this), "Can't withdraw native tokens");
1458         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1459         _sent = IERC20(_token).transfer(_to, _contractBalance);
1460         emit TransferForeignToken(_token, _contractBalance);
1461     }
1462 
1463 }