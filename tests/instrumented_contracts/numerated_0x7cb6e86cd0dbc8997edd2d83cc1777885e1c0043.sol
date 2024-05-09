1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4     Eight TOKEN
5     https://twitter.com/elonmusk/status/1587523701452464131
6     
7 */
8 
9 pragma solidity 0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return payable(msg.sender);
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30 
31     function allowance(address owner, address spender)
32         external
33         view
34         returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(
65         uint256 a,
66         uint256 b,
67         string memory errorMessage
68     ) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99         return c;
100     }
101 
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         return mod(a, b, "SafeMath: modulo by zero");
104     }
105 
106     function mod(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b != 0, errorMessage);
112         return a % b;
113     }
114 }
115 
116 library Address {
117     function isContract(address account) internal view returns (bool) {
118         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
119         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
120         // for accounts without code, i.e. `keccak256('')`
121         bytes32 codehash;
122         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
123         // solhint-disable-next-line no-inline-assembly
124         assembly {
125             codehash := extcodehash(account)
126         }
127         return (codehash != accountHash && codehash != 0x0);
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(
132             address(this).balance >= amount,
133             "Address: insufficient balance"
134         );
135 
136         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
137         (bool success, ) = recipient.call{value: amount}("");
138         require(
139             success,
140             "Address: unable to send value, recipient may have reverted"
141         );
142     }
143 
144     function functionCall(address target, bytes memory data)
145         internal
146         returns (bytes memory)
147     {
148         return functionCall(target, data, "Address: low-level call failed");
149     }
150 
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return _functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value
163     ) internal returns (bytes memory) {
164         return
165             functionCallWithValue(
166                 target,
167                 data,
168                 value,
169                 "Address: low-level call with value failed"
170             );
171     }
172 
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(
180             address(this).balance >= value,
181             "Address: insufficient balance for call"
182         );
183         return _functionCallWithValue(target, data, value, errorMessage);
184     }
185 
186     function _functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 weiValue,
190         string memory errorMessage
191     ) private returns (bytes memory) {
192         require(isContract(target), "Address: call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.call{value: weiValue}(
195             data
196         );
197         if (success) {
198             return returndata;
199         } else {
200             if (returndata.length > 0) {
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 contract Ownable is Context {
213     address private _owner;
214     address private _previousOwner;
215     uint256 private _lockTime;
216 
217     event OwnershipTransferred(
218         address indexed previousOwner,
219         address indexed newOwner
220     );
221 
222     constructor() {
223         address msgSender = _msgSender();
224         _owner = msgSender;
225         emit OwnershipTransferred(address(0), msgSender);
226     }
227 
228     function owner() public view returns (address) {
229         return _owner;
230     }
231 
232     modifier onlyOwner() {
233         require(_owner == _msgSender(), "Ownable: caller is not the owner");
234         _;
235     }
236 
237     function renounceOwnership() public virtual onlyOwner {
238         emit OwnershipTransferred(_owner, address(0));
239         _owner = address(0);
240     }
241 
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(
244             newOwner != address(0),
245             "Ownable: new owner is the zero address"
246         );
247         emit OwnershipTransferred(_owner, newOwner);
248         _owner = newOwner;
249     }
250 
251     function getUnlockTime() public view returns (uint256) {
252         return _lockTime;
253     }
254 
255     function getTime() public view returns (uint256) {
256         return block.timestamp;
257     }
258 }
259 
260 
261 interface IUniswapV2Factory {
262     event PairCreated(
263         address indexed token0,
264         address indexed token1,
265         address pair,
266         uint256
267     );
268 
269     function feeTo() external view returns (address);
270 
271     function feeToSetter() external view returns (address);
272 
273     function getPair(address tokenA, address tokenB)
274         external
275         view
276         returns (address pair);
277 
278     function allPairs(uint256) external view returns (address pair);
279 
280     function allPairsLength() external view returns (uint256);
281 
282     function createPair(address tokenA, address tokenB)
283         external
284         returns (address pair);
285 
286     function setFeeTo(address) external;
287 
288     function setFeeToSetter(address) external;
289 }
290 
291 
292 interface IUniswapV2Pair {
293     event Approval(
294         address indexed owner,
295         address indexed spender,
296         uint256 value
297     );
298     event Transfer(address indexed from, address indexed to, uint256 value);
299 
300     function name() external pure returns (string memory);
301 
302     function symbol() external pure returns (string memory);
303 
304     function decimals() external pure returns (uint8);
305 
306     function totalSupply() external view returns (uint256);
307 
308     function balanceOf(address owner) external view returns (uint256);
309 
310     function allowance(address owner, address spender)
311         external
312         view
313         returns (uint256);
314 
315     function approve(address spender, uint256 value) external returns (bool);
316 
317     function transfer(address to, uint256 value) external returns (bool);
318 
319     function transferFrom(
320         address from,
321         address to,
322         uint256 value
323     ) external returns (bool);
324 
325     function DOMAIN_SEPARATOR() external view returns (bytes32);
326 
327     function PERMIT_TYPEHASH() external pure returns (bytes32);
328 
329     function nonces(address owner) external view returns (uint256);
330 
331     function permit(
332         address owner,
333         address spender,
334         uint256 value,
335         uint256 deadline,
336         uint8 v,
337         bytes32 r,
338         bytes32 s
339     ) external;
340 
341     event Burn(
342         address indexed sender,
343         uint256 amount0,
344         uint256 amount1,
345         address indexed to
346     );
347     event Swap(
348         address indexed sender,
349         uint256 amount0In,
350         uint256 amount1In,
351         uint256 amount0Out,
352         uint256 amount1Out,
353         address indexed to
354     );
355     event Sync(uint112 reserve0, uint112 reserve1);
356 
357     function MINIMUM_LIQUIDITY() external pure returns (uint256);
358 
359     function factory() external view returns (address);
360 
361     function token0() external view returns (address);
362 
363     function token1() external view returns (address);
364 
365     function getReserves()
366         external
367         view
368         returns (
369             uint112 reserve0,
370             uint112 reserve1,
371             uint32 blockTimestampLast
372         );
373 
374     function price0CumulativeLast() external view returns (uint256);
375 
376     function price1CumulativeLast() external view returns (uint256);
377 
378     function kLast() external view returns (uint256);
379 
380     function burn(address to)
381         external
382         returns (uint256 amount0, uint256 amount1);
383 
384     function swap(
385         uint256 amount0Out,
386         uint256 amount1Out,
387         address to,
388         bytes calldata data
389     ) external;
390 
391     function skim(address to) external;
392 
393     function sync() external;
394 
395     function initialize(address, address) external;
396 }
397 
398 interface IUniswapV2Router01 {
399     function factory() external pure returns (address);
400 
401     function WETH() external pure returns (address);
402 
403     function addLiquidity(
404         address tokenA,
405         address tokenB,
406         uint256 amountADesired,
407         uint256 amountBDesired,
408         uint256 amountAMin,
409         uint256 amountBMin,
410         address to,
411         uint256 deadline
412     )
413         external
414         returns (
415             uint256 amountA,
416             uint256 amountB,
417             uint256 liquidity
418         );
419 
420     function addLiquidityETH(
421         address token,
422         uint256 amountTokenDesired,
423         uint256 amountTokenMin,
424         uint256 amountETHMin,
425         address to,
426         uint256 deadline
427     )
428         external
429         payable
430         returns (
431             uint256 amountToken,
432             uint256 amountETH,
433             uint256 liquidity
434         );
435 
436     function removeLiquidity(
437         address tokenA,
438         address tokenB,
439         uint256 liquidity,
440         uint256 amountAMin,
441         uint256 amountBMin,
442         address to,
443         uint256 deadline
444     ) external returns (uint256 amountA, uint256 amountB);
445 
446     function removeLiquidityETH(
447         address token,
448         uint256 liquidity,
449         uint256 amountTokenMin,
450         uint256 amountETHMin,
451         address to,
452         uint256 deadline
453     ) external returns (uint256 amountToken, uint256 amountETH);
454 
455     function removeLiquidityWithPermit(
456         address tokenA,
457         address tokenB,
458         uint256 liquidity,
459         uint256 amountAMin,
460         uint256 amountBMin,
461         address to,
462         uint256 deadline,
463         bool approveMax,
464         uint8 v,
465         bytes32 r,
466         bytes32 s
467     ) external returns (uint256 amountA, uint256 amountB);
468 
469     function removeLiquidityETHWithPermit(
470         address token,
471         uint256 liquidity,
472         uint256 amountTokenMin,
473         uint256 amountETHMin,
474         address to,
475         uint256 deadline,
476         bool approveMax,
477         uint8 v,
478         bytes32 r,
479         bytes32 s
480     ) external returns (uint256 amountToken, uint256 amountETH);
481 
482     function swapExactTokensForTokens(
483         uint256 amountIn,
484         uint256 amountOutMin,
485         address[] calldata path,
486         address to,
487         uint256 deadline
488     ) external returns (uint256[] memory amounts);
489 
490     function swapTokensForExactTokens(
491         uint256 amountOut,
492         uint256 amountInMax,
493         address[] calldata path,
494         address to,
495         uint256 deadline
496     ) external returns (uint256[] memory amounts);
497 
498     function swapExactETHForTokens(
499         uint256 amountOutMin,
500         address[] calldata path,
501         address to,
502         uint256 deadline
503     ) external payable returns (uint256[] memory amounts);
504 
505     function swapTokensForExactETH(
506         uint256 amountOut,
507         uint256 amountInMax,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external returns (uint256[] memory amounts);
512 
513     function swapExactTokensForETH(
514         uint256 amountIn,
515         uint256 amountOutMin,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external returns (uint256[] memory amounts);
520 
521     function swapETHForExactTokens(
522         uint256 amountOut,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external payable returns (uint256[] memory amounts);
527 
528     function quote(
529         uint256 amountA,
530         uint256 reserveA,
531         uint256 reserveB
532     ) external pure returns (uint256 amountB);
533 
534     function getAmountOut(
535         uint256 amountIn,
536         uint256 reserveIn,
537         uint256 reserveOut
538     ) external pure returns (uint256 amountOut);
539 
540     function getAmountIn(
541         uint256 amountOut,
542         uint256 reserveIn,
543         uint256 reserveOut
544     ) external pure returns (uint256 amountIn);
545 
546     function getAmountsOut(uint256 amountIn, address[] calldata path)
547         external
548         view
549         returns (uint256[] memory amounts);
550 
551     function getAmountsIn(uint256 amountOut, address[] calldata path)
552         external
553         view
554         returns (uint256[] memory amounts);
555 }
556 
557 interface IUniswapV2Router02 is IUniswapV2Router01 {
558     function removeLiquidityETHSupportingFeeOnTransferTokens(
559         address token,
560         uint256 liquidity,
561         uint256 amountTokenMin,
562         uint256 amountETHMin,
563         address to,
564         uint256 deadline
565     ) external returns (uint256 amountETH);
566 
567     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
568         address token,
569         uint256 liquidity,
570         uint256 amountTokenMin,
571         uint256 amountETHMin,
572         address to,
573         uint256 deadline,
574         bool approveMax,
575         uint8 v,
576         bytes32 r,
577         bytes32 s
578     ) external returns (uint256 amountETH);
579 
580     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
581         uint256 amountIn,
582         uint256 amountOutMin,
583         address[] calldata path,
584         address to,
585         uint256 deadline
586     ) external;
587 
588     function swapExactETHForTokensSupportingFeeOnTransferTokens(
589         uint256 amountOutMin,
590         address[] calldata path,
591         address to,
592         uint256 deadline
593     ) external payable;
594 
595     function swapExactTokensForETHSupportingFeeOnTransferTokens(
596         uint256 amountIn,
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external;
602 }
603 
604 contract Eight is Context, IERC20, Ownable {
605     using SafeMath for uint256;
606     using Address for address;
607 
608     address payable public marketingAddress = payable(0x452726851639a58836f1090fdBDf61499F77F157); // Marketing Address
609     address payable public multiSigAddress = payable(0x452726851639a58836f1090fdBDf61499F77F157); // Marketing Address
610     address payable public devAddress = payable(0x452726851639a58836f1090fdBDf61499F77F157); // Dev Address
611     address payable public liquidityAddress = payable(0x452726851639a58836f1090fdBDf61499F77F157); // Liquidity Address
612 
613     mapping(address => uint256) private _rOwned;
614     mapping(address => uint256) private _tOwned;
615     mapping(address => mapping(address => uint256)) private _allowances;
616 
617     mapping(address => bool) private _isExcludedFromFee;
618 
619     mapping(address => bool) private _isExcluded;
620     address[] private _excluded;
621 
622     uint256 private constant MAX = ~uint256(0);
623     uint256 private constant _tTotal = 1 * 1e6 * 1e18;
624     uint256 private _rTotal = (MAX - (MAX % _tTotal));
625     uint256 private _tFeeTotal;
626 
627     string private constant _name = unicode"Eight";
628     string private constant _symbol = unicode"$8";
629     uint8 private constant _decimals = 18;
630 
631     uint256 private constant BUY = 1;
632     uint256 private constant SELL = 2;
633     uint256 private constant TRANSFER = 3;
634     uint256 private buyOrSellSwitch;
635 
636     uint256 public manualBurnFrequency = 30 minutes;
637     uint256 public lastManualLpBurnTime;
638 
639     uint256 private _taxFee;
640     uint256 private _previousTaxFee = _taxFee;
641 
642     uint256 private _liquidityFee;
643     uint256 private _previousLiquidityFee = _liquidityFee;
644 
645     uint256 public _buyTaxFee;
646     uint256 public _buyLiquidityFee = 0;
647     uint256 public _buyMultiSigFee = 0;
648     uint256 public _buyMarketingFee = 0;
649     uint256 public _buyDevFee = 20;
650 
651     uint256 public _sellTaxFee;
652     uint256 public _sellLiquidityFee = 0;
653     uint256 public _sellMultiSigFee = 0;
654     uint256 public _sellMarketingFee = 0;
655     uint256 public _sellDevFee = 20;
656 
657     uint256 public liquidityActiveBlock; // 0 means liquidity is not active yet
658     uint256 public tradingActiveBlock; // 0 means trading is not active
659     uint256 public deadBlocks;
660 
661     bool public limitsInEffect = true;
662     bool public tradingActive = false;
663     bool public swapEnabled = false;
664 
665     mapping (address => bool) public _isExcludedMaxTransactionAmount;
666 
667      // Anti-bot and anti-whale mappings and variables
668     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
669     bool public transferDelayEnabled = true;
670 
671     uint256 private _liquidityTokensToSwap;
672     uint256 private _marketingTokensToSwap;
673     uint256 private _devTokensToSwap;
674     uint256 private _multiSigTokensToSwap;
675 
676     bool private gasLimitActive = true;
677     uint256 private gasPriceLimit = 602 * 1 gwei;
678 
679     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
680     // could be subject to a maximum transfer amount
681     mapping (address => bool) public automatedMarketMakerPairs;
682     mapping (address => bool) private _isSniper;
683 
684     uint256 public minimumTokensBeforeSwap;
685     uint256 public maxTransactionAmount;
686     uint256 public maxWallet;
687 
688     IUniswapV2Router02 public uniswapV2Router;
689     address public uniswapV2Pair;
690 
691     bool inSwapAndLiquify;
692     bool public swapAndLiquifyEnabled = false;
693 
694     event RewardLiquidityProviders(uint256 tokenAmount);
695     event SwapAndLiquifyEnabledUpdated(bool enabled);
696     event SwapAndLiquify(
697         uint256 tokensSwapped,
698         uint256 ethReceived,
699         uint256 tokensIntoLiqudity
700     );
701 
702     event SwapETHForTokens(uint256 amountIn, address[] path);
703 
704     event SwapTokensForETH(uint256 amountIn, address[] path);
705 
706     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
707 
708     event ManualBurnLP();
709 
710     modifier lockTheSwap() {
711         inSwapAndLiquify = true;
712         _;
713         inSwapAndLiquify = false;
714     }
715 
716     constructor() {
717         address newOwner = msg.sender; // update if auto-deploying to a different wallet        
718 
719         deadBlocks = 0;
720 
721         maxTransactionAmount = _tTotal * 200 / 10000; // 2% max txn
722         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
723         maxWallet = _tTotal * 200 / 10000; // 2%
724 
725         _rOwned[newOwner] = _rTotal;
726 
727         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
728             // ROPSTEN or HARDHAT
729             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
730         );
731 
732         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
733             .createPair(address(this), _uniswapV2Router.WETH());
734 
735         uniswapV2Router = _uniswapV2Router;
736         uniswapV2Pair = _uniswapV2Pair;
737 
738         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
739 
740         _isExcludedFromFee[newOwner] = true;
741         _isExcludedFromFee[address(this)] = true;
742         _isExcludedFromFee[liquidityAddress] = true;
743 
744         excludeFromMaxTransaction(newOwner, true);
745         excludeFromMaxTransaction(address(this), true);
746         excludeFromMaxTransaction(address(_uniswapV2Router), true);
747         excludeFromMaxTransaction(address(0xdead), true);
748 
749         emit Transfer(address(0), newOwner, _tTotal);
750     }
751 
752     function name() external pure returns (string memory) {
753         return _name;
754     }
755 
756     function symbol() external pure returns (string memory) {
757         return _symbol;
758     }
759 
760     function decimals() external pure returns (uint8) {
761         return _decimals;
762     }
763 
764     function totalSupply() external pure override returns (uint256) {
765         return _tTotal;
766     }
767 
768     function balanceOf(address account) public view override returns (uint256) {
769         if (_isExcluded[account]) return _tOwned[account];
770         return tokenFromReflection(_rOwned[account]);
771     }
772 
773     function transfer(address recipient, uint256 amount)
774         external
775         override
776         returns (bool)
777     {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender)
783         external
784         view
785         override
786         returns (uint256)
787     {
788         return _allowances[owner][spender];
789     }
790 
791     function approve(address spender, uint256 amount)
792         public
793         override
794         returns (bool)
795     {
796         _approve(_msgSender(), spender, amount);
797         return true;
798     }
799 
800     function transferFrom(
801         address sender,
802         address recipient,
803         uint256 amount
804     ) external override returns (bool) {
805         _transfer(sender, recipient, amount);
806         _approve(
807             sender,
808             _msgSender(),
809             _allowances[sender][_msgSender()].sub(
810                 amount,
811                 "ERC20: transfer amount exceeds allowance"
812             )
813         );
814         return true;
815     }
816 
817     function increaseAllowance(address spender, uint256 addedValue)
818         external
819         virtual
820         returns (bool)
821     {
822         _approve(
823             _msgSender(),
824             spender,
825             _allowances[_msgSender()][spender].add(addedValue)
826         );
827         return true;
828     }
829 
830     function decreaseAllowance(address spender, uint256 subtractedValue)
831         external
832         virtual
833         returns (bool)
834     {
835         _approve(
836             _msgSender(),
837             spender,
838             _allowances[_msgSender()][spender].sub(
839                 subtractedValue,
840                 "ERC20: decreased allowance below zero"
841             )
842         );
843         return true;
844     }
845 
846     function isExcludedFromReward(address account)
847         external
848         view
849         returns (bool)
850     {
851         return _isExcluded[account];
852     }
853 
854     function totalFees() external view returns (uint256) {
855         return _tFeeTotal;
856     }
857 
858     // once enabled, can never be turned off
859     function enableTrading(uint256 _deadBlocks) external onlyOwner {
860         tradingActive = true;
861         swapAndLiquifyEnabled = true;
862         tradingActiveBlock = block.number;
863         deadBlocks = _deadBlocks;
864     }
865 
866     function isSniper(address account) public view returns (bool) {
867         return _isSniper[account];
868     }
869     
870     function manageSnipers(address[] calldata addresses, bool status) public onlyOwner {
871         for (uint256 i; i < addresses.length; ++i) {
872             _isSniper[addresses[i]] = status;
873         }
874     }
875 
876     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
877         return minimumTokensBeforeSwap;
878     }
879 
880     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
881         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
882 
883         _setAutomatedMarketMakerPair(pair, value);
884     }
885 
886     function _setAutomatedMarketMakerPair(address pair, bool value) private {
887         automatedMarketMakerPairs[pair] = value;
888 
889         excludeFromMaxTransaction(pair, value);
890         if(value){excludeFromReward(pair);}
891         if(!value){includeInReward(pair);}
892     }
893 
894     function setProtectionSettings(bool antiGas) external onlyOwner() {
895         gasLimitActive = antiGas;
896     }
897 
898     function setGasPriceLimit(uint256 gas) external onlyOwner {
899         require(gas >= 300);
900         gasPriceLimit = gas * 1 gwei;
901     }
902 
903     // disable Transfer delay
904     function disableTransferDelay() external onlyOwner returns (bool){
905         transferDelayEnabled = false;
906         return true;
907     }
908 
909     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
910         external
911         view
912         returns (uint256)
913     {
914         require(tAmount <= _tTotal, "Amount must be less than supply");
915         if (!deductTransferFee) {
916             (uint256 rAmount, , , , , ) = _getValues(tAmount);
917             return rAmount;
918         } else {
919             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
920             return rTransferAmount;
921         }
922     }
923 
924     // for one-time airdrop feature after contract launch
925     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
926         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
927         removeAllFee();
928         buyOrSellSwitch = TRANSFER;
929         for(uint256 i = 0; i < airdropWallets.length; i++){
930             address wallet = airdropWallets[i];
931             uint256 airdropAmount = amount[i];
932             _tokenTransfer(msg.sender, wallet, airdropAmount);
933         }
934         restoreAllFee();
935     }
936 
937     // remove limits after token is stable - 30-60 minutes
938     function removeLimits() external onlyOwner returns (bool){
939         limitsInEffect = false;
940         gasLimitActive = false;
941         transferDelayEnabled = false;
942         return true;
943     }
944 
945     function tokenFromReflection(uint256 rAmount)
946         public
947         view
948         returns (uint256)
949     {
950         require(
951             rAmount <= _rTotal,
952             "Amount must be less than total reflections"
953         );
954         uint256 currentRate = _getRate();
955         return rAmount.div(currentRate);
956     }
957 
958     function excludeFromReward(address account) public onlyOwner {
959         require(!_isExcluded[account], "Account is already excluded");
960         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
961         if (_rOwned[account] > 0) {
962             _tOwned[account] = tokenFromReflection(_rOwned[account]);
963         }
964         _isExcluded[account] = true;
965         _excluded.push(account);
966     }
967 
968     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
969         _isExcludedMaxTransactionAmount[updAds] = isEx;
970         emit ExcludedMaxTransactionAmount(updAds, isEx);
971     }
972 
973     function includeInReward(address account) public onlyOwner {
974         require(_isExcluded[account], "Account is not excluded");
975         for (uint256 i = 0; i < _excluded.length; i++) {
976             if (_excluded[i] == account) {
977                 _excluded[i] = _excluded[_excluded.length - 1];
978                 _tOwned[account] = 0;
979                 _isExcluded[account] = false;
980                 _excluded.pop();
981                 break;
982             }
983         }
984     }
985 
986     function _approve(
987         address owner,
988         address spender,
989         uint256 amount
990     ) private {
991         require(owner != address(0), "ERC20: approve from the zero address");
992         require(spender != address(0), "ERC20: approve to the zero address");
993 
994         _allowances[owner][spender] = amount;
995         emit Approval(owner, spender, amount);
996     }
997 
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 amount
1002     ) private {
1003         // require(from != address(0), "ERC20: transfer from the zero address");
1004         // require(to != address(0), "ERC20: transfer to the zero address");
1005         require(!_isSniper[to], "You have no power here!");
1006         require(!_isSniper[from], "You have no power here!");
1007         require(amount > 0, "Transfer amount must be greater than zero");
1008 
1009         if(limitsInEffect){
1010             if (
1011                 from != owner() &&
1012                 to != owner() &&
1013                 to != address(0) &&
1014                 to != address(0xdead) &&
1015                 !inSwapAndLiquify
1016             ){
1017                 require(tradingActive, "Trading is not active yet");
1018                 if((tradingActiveBlock > 0 && tradingActiveBlock + deadBlocks > block.number)){
1019                     _isSniper[to] = true;
1020                 }
1021 
1022                 // only use to prevent sniper buys in the first blocks.
1023                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1024                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1025                 }
1026 
1027                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1028                 if (transferDelayEnabled){
1029                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1030                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1031                         _holderLastTransferTimestamp[tx.origin] = block.number;
1032                     }
1033                 }
1034 
1035                 //when buy
1036                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1037                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1038                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1039                 }
1040                 //when sell
1041                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1042                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1043                 }
1044                 else if (!_isExcludedMaxTransactionAmount[to]){
1045                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1046                 }
1047             }
1048         }
1049 
1050         uint256 contractTokenBalance = balanceOf(address(this));
1051         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1052 
1053         // Sell tokens for ETH
1054         if (
1055             !inSwapAndLiquify &&
1056             swapAndLiquifyEnabled &&
1057             balanceOf(uniswapV2Pair) > 0 &&
1058             overMinimumTokenBalance &&
1059             automatedMarketMakerPairs[to]
1060         ) {
1061             swapBack();
1062         }
1063 
1064         removeAllFee();
1065 
1066         buyOrSellSwitch = TRANSFER;
1067 
1068         // If any account belongs to _isExcludedFromFee account then remove the fee
1069         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1070             // Buy
1071             if (automatedMarketMakerPairs[from]) {
1072                 _taxFee = _buyTaxFee;
1073                 
1074                 _liquidityFee = _buyLiquidityFee + _buyMultiSigFee + _buyMarketingFee + _buyDevFee;
1075                 if(_liquidityFee > 0){
1076                     buyOrSellSwitch = BUY;
1077                 }
1078             }
1079             // Sell
1080             else if (automatedMarketMakerPairs[to]) {
1081                 _taxFee = _sellTaxFee;
1082                 _liquidityFee = _sellLiquidityFee + _sellMultiSigFee + _sellMarketingFee + _sellDevFee;
1083                 if(_liquidityFee > 0){
1084                     buyOrSellSwitch = SELL;
1085                 }
1086             }
1087         }
1088 
1089         _tokenTransfer(from, to, amount);
1090 
1091         restoreAllFee();
1092 
1093     }
1094     
1095     // change the minimum amount of tokens to sell from fees
1096     function updateSwapTokensAtPercent(uint256 percent) external onlyOwner returns (bool){
1097   	    require(percent >= 1, "Swap amount cannot be lower than 0.001% total supply.");
1098   	    require(percent <= 50, "Swap amount cannot be higher than 0.5% total supply.");
1099   	    minimumTokensBeforeSwap = _tTotal * percent / 10000;
1100   	    return true;
1101   	}
1102 
1103     function updateMaxTxnPercent(uint256 percent) external onlyOwner {
1104         require(percent >= 10, "Cannot set maxTransactionAmount lower than 0.1%");
1105         maxTransactionAmount = _tTotal * percent / 10000;
1106     }
1107 
1108     // percent 25 for .25%
1109     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1110         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1111         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1112         lastManualLpBurnTime = block.timestamp;
1113         
1114         // get balance of liquidity pair
1115         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1116         
1117         // calculate amount to burn
1118         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1119         
1120         // pull tokens from pancakePair liquidity and move to dead address permanently
1121         if (amountToBurn > 0){
1122             _transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1123         }
1124         
1125         //sync price since this is not in a swap transaction!
1126         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1127         pair.sync();
1128         emit ManualBurnLP();
1129         return true;
1130     }
1131 
1132     function swapBack() private lockTheSwap {
1133         uint256 contractBalance = balanceOf(address(this));
1134         bool success;
1135         uint256 totalTokensToSwap = _liquidityTokensToSwap + _devTokensToSwap + _multiSigTokensToSwap + _marketingTokensToSwap;
1136         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1137 
1138         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1139         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1140 
1141         uint256 initialETHBalance = address(this).balance;
1142 
1143         swapTokensForETH(amountToSwapForETH);
1144 
1145         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1146 
1147         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1148 
1149         uint256 ethForDev = ethBalance.mul(_devTokensToSwap).div(totalTokensToSwap);
1150 
1151         uint256 ethForMultiSig = ethBalance.mul(_multiSigTokensToSwap).div(totalTokensToSwap);
1152 
1153         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1154 
1155         _liquidityTokensToSwap = 0;
1156         _devTokensToSwap = 0;
1157         _multiSigTokensToSwap = 0;
1158         _marketingTokensToSwap = 0;
1159 
1160         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
1161             addLiquidity(tokensForLiquidity, ethForLiquidity);
1162             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1163         }
1164 
1165         address(marketingAddress).call{value: ethForMarketing}("");
1166         address(multiSigAddress).call{value: ethForMultiSig}("");
1167         (success,) = address(devAddress).call{value: address(this).balance}("");
1168     }
1169 
1170     function swapTokensForETH(uint256 tokenAmount) private {
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174         _approve(address(this), address(uniswapV2Router), tokenAmount);
1175         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1176             tokenAmount,
1177             0, // accept any amount of ETH
1178             path,
1179             address(this),
1180             block.timestamp
1181         );
1182     }
1183 
1184     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1185         _approve(address(this), address(uniswapV2Router), tokenAmount);
1186         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1187             address(this),
1188             tokenAmount,
1189             0, // slippage is unavoidable
1190             0, // slippage is unavoidable
1191             liquidityAddress,
1192             block.timestamp
1193         );
1194     }
1195 
1196     function _tokenTransfer(
1197         address sender,
1198         address recipient,
1199         uint256 amount
1200     ) private {
1201 
1202         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1203             _transferFromExcluded(sender, recipient, amount);
1204         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1205             _transferToExcluded(sender, recipient, amount);
1206         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1207             _transferBothExcluded(sender, recipient, amount);
1208         } else {
1209             _transferStandard(sender, recipient, amount);
1210         }
1211     }
1212 
1213     function _transferStandard(
1214         address sender,
1215         address recipient,
1216         uint256 tAmount
1217     ) private {
1218         (
1219             uint256 rAmount,
1220             uint256 rTransferAmount,
1221             uint256 rFee,
1222             uint256 tTransferAmount,
1223             uint256 tFee,
1224             uint256 tLiquidity
1225         ) = _getValues(tAmount);
1226         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1228         _takeLiquidity(tLiquidity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233     function _transferToExcluded(
1234         address sender,
1235         address recipient,
1236         uint256 tAmount
1237     ) private {
1238         (
1239             uint256 rAmount,
1240             uint256 rTransferAmount,
1241             uint256 rFee,
1242             uint256 tTransferAmount,
1243             uint256 tFee,
1244             uint256 tLiquidity
1245         ) = _getValues(tAmount);
1246         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1247         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1248         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1249         _takeLiquidity(tLiquidity);
1250         _reflectFee(rFee, tFee);
1251         emit Transfer(sender, recipient, tTransferAmount);
1252     }
1253 
1254     function _transferFromExcluded(
1255         address sender,
1256         address recipient,
1257         uint256 tAmount
1258     ) private {
1259         (
1260             uint256 rAmount,
1261             uint256 rTransferAmount,
1262             uint256 rFee,
1263             uint256 tTransferAmount,
1264             uint256 tFee,
1265             uint256 tLiquidity
1266         ) = _getValues(tAmount);
1267         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1268         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1269         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1270         _takeLiquidity(tLiquidity);
1271         _reflectFee(rFee, tFee);
1272         emit Transfer(sender, recipient, tTransferAmount);
1273     }
1274 
1275     function _transferBothExcluded(
1276         address sender,
1277         address recipient,
1278         uint256 tAmount
1279     ) private {
1280         (
1281             uint256 rAmount,
1282             uint256 rTransferAmount,
1283             uint256 rFee,
1284             uint256 tTransferAmount,
1285             uint256 tFee,
1286             uint256 tLiquidity
1287         ) = _getValues(tAmount);
1288         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1289         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1290         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1291         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1292         _takeLiquidity(tLiquidity);
1293         _reflectFee(rFee, tFee);
1294         emit Transfer(sender, recipient, tTransferAmount);
1295     }
1296 
1297     function _reflectFee(uint256 rFee, uint256 tFee) private {
1298         _rTotal = _rTotal.sub(rFee);
1299         _tFeeTotal = _tFeeTotal.add(tFee);
1300     }
1301 
1302     function _getValues(uint256 tAmount)
1303         private
1304         view
1305         returns (
1306             uint256,
1307             uint256,
1308             uint256,
1309             uint256,
1310             uint256,
1311             uint256
1312         )
1313     {
1314         (
1315             uint256 tTransferAmount,
1316             uint256 tFee,
1317             uint256 tLiquidity
1318         ) = _getTValues(tAmount);
1319         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1320             tAmount,
1321             tFee,
1322             tLiquidity,
1323             _getRate()
1324         );
1325         return (
1326             rAmount,
1327             rTransferAmount,
1328             rFee,
1329             tTransferAmount,
1330             tFee,
1331             tLiquidity
1332         );
1333     }
1334 
1335     function _getTValues(uint256 tAmount)
1336         private
1337         view
1338         returns (
1339             uint256,
1340             uint256,
1341             uint256
1342         )
1343     {
1344         uint256 tFee = calculateTaxFee(tAmount);
1345         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1346         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1347         return (tTransferAmount, tFee, tLiquidity);
1348     }
1349 
1350     function _getRValues(
1351         uint256 tAmount,
1352         uint256 tFee,
1353         uint256 tLiquidity,
1354         uint256 currentRate
1355     )
1356         private
1357         pure
1358         returns (
1359             uint256,
1360             uint256,
1361             uint256
1362         )
1363     {
1364         uint256 rAmount = tAmount.mul(currentRate);
1365         uint256 rFee = tFee.mul(currentRate);
1366         uint256 rLiquidity = tLiquidity.mul(currentRate);
1367         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1368         return (rAmount, rTransferAmount, rFee);
1369     }
1370 
1371     function _getRate() private view returns (uint256) {
1372         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1373         return rSupply.div(tSupply);
1374     }
1375 
1376     function _getCurrentSupply() private view returns (uint256, uint256) {
1377         uint256 rSupply = _rTotal;
1378         uint256 tSupply = _tTotal;
1379         for (uint256 i = 0; i < _excluded.length; i++) {
1380             if (
1381                 _rOwned[_excluded[i]] > rSupply ||
1382                 _tOwned[_excluded[i]] > tSupply
1383             ) return (_rTotal, _tTotal);
1384             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1385             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1386         }
1387         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1388         return (rSupply, tSupply);
1389     }
1390 
1391     function _takeLiquidity(uint256 tLiquidity) private {
1392         if(buyOrSellSwitch == BUY){
1393             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1394             _devTokensToSwap += tLiquidity * _buyDevFee / _liquidityFee;
1395             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1396             _multiSigTokensToSwap += tLiquidity * _buyMultiSigFee / _liquidityFee;
1397         } else if(buyOrSellSwitch == SELL){
1398             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1399             _devTokensToSwap += tLiquidity * _sellDevFee / _liquidityFee;
1400             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1401             _multiSigTokensToSwap += tLiquidity * _sellMultiSigFee / _liquidityFee;
1402         }
1403         
1404         uint256 currentRate = _getRate();
1405         uint256 rLiquidity = tLiquidity.mul(currentRate);
1406         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1407         if (_isExcluded[address(this)])
1408             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1409     }
1410 
1411     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1412         return _amount.mul(_taxFee).div(10**3);
1413     }
1414 
1415     function calculateLiquidityFee(uint256 _amount)
1416         private
1417         view
1418         returns (uint256)
1419     {
1420         return _amount.mul(_liquidityFee).div(10**3);
1421     }
1422 
1423     function removeAllFee() private {
1424         if (_taxFee == 0 && _liquidityFee == 0) return;
1425 
1426         _previousTaxFee = _taxFee;
1427         _previousLiquidityFee = _liquidityFee;
1428 
1429         _taxFee = 0;
1430         _liquidityFee = 0;
1431     }
1432 
1433     function restoreAllFee() private {
1434         _taxFee = _previousTaxFee;
1435         _liquidityFee = _previousLiquidityFee;
1436     }
1437 
1438     function isExcludedFromFee(address account) external view returns (bool) {
1439         return _isExcludedFromFee[account];
1440     }
1441 
1442     function excludeFromFee(address account) external onlyOwner {
1443         _isExcludedFromFee[account] = true;
1444     }
1445 
1446     function includeInFee(address account) external onlyOwner {
1447         _isExcludedFromFee[account] = false;
1448     }
1449 
1450     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyDevFee, uint256 buyMultiSigFee, uint256 buyMarketingFee)
1451         external
1452         onlyOwner
1453     {
1454         _buyTaxFee = buyTaxFee;
1455         _buyLiquidityFee = buyLiquidityFee;
1456         _buyMultiSigFee = buyMultiSigFee;
1457         _buyDevFee = buyDevFee;
1458         _buyMarketingFee = buyMarketingFee;
1459         require(_buyTaxFee + _buyLiquidityFee + _buyMultiSigFee + _buyDevFee + _buyMarketingFee <= 150, "Must keep taxes below 15%");
1460     }
1461 
1462     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellDevFee, uint256 sellMultiSigFee, uint256 sellMarketingFee)
1463         external
1464         onlyOwner
1465     {
1466         _sellTaxFee = sellTaxFee;
1467         _sellLiquidityFee = sellLiquidityFee;
1468         _sellMultiSigFee = sellMultiSigFee;
1469         _sellDevFee = sellDevFee;
1470         _sellMarketingFee = sellMarketingFee;
1471         require(_sellTaxFee + _sellLiquidityFee + _sellMultiSigFee + _sellDevFee + _sellMarketingFee <= 250, "Must keep taxes below 25%");
1472     }
1473 
1474     function updateMaxSize(uint256 percent) external onlyOwner {
1475         maxWallet = _tTotal * percent / 10000; // 300 = 3%
1476         maxTransactionAmount = _tTotal * percent / 10000;
1477     }
1478 
1479     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1480         marketingAddress = payable(_marketingAddress);
1481         _isExcludedFromFee[marketingAddress] = true;
1482     }
1483 
1484     function setDevAddress(address _devAddress) external onlyOwner {
1485         devAddress = payable(_devAddress);
1486         _isExcludedFromFee[devAddress] = true;
1487     }
1488 
1489     function setMultiSigAddress(address _multiSigAddress) external onlyOwner {
1490         multiSigAddress = payable(_multiSigAddress);
1491         _isExcludedFromFee[multiSigAddress] = true;
1492     }
1493 
1494     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1495         liquidityAddress = payable(_liquidityAddress);
1496         _isExcludedFromFee[liquidityAddress] = true;
1497     }
1498 
1499     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1500         swapAndLiquifyEnabled = _enabled;
1501         emit SwapAndLiquifyEnabledUpdated(_enabled);
1502     }
1503     
1504     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1505     function buyBackTokens(uint256 ethAmountInWei) external onlyOwner {
1506         // generate the uniswap pair path of weth -> eth
1507         address[] memory path = new address[](2);
1508         path[0] = uniswapV2Router.WETH();
1509         path[1] = address(this);
1510 
1511         // make the swap
1512         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1513             0, // accept any amount of Token
1514             path,
1515             address(0xdead),
1516             block.timestamp
1517         );
1518     }
1519 
1520     // To receive ETH from uniswapV2Router when swapping
1521     receive() external payable {}
1522 
1523     function transferForeignToken(address _token, address _to)
1524         external
1525         onlyOwner
1526         returns (bool _sent)
1527     {
1528         require(_token != address(this), "Can't withdraw native tokens");
1529         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1530         _sent = IERC20(_token).transfer(_to, _contractBalance);
1531     }
1532 
1533     function manualSend(address _recipient) external onlyOwner {
1534         uint256 contractETHBalance = address(this).balance;
1535         (bool success, ) = _recipient.call{ value: contractETHBalance }("");
1536         require(success, "Address: unable to send value, recipient may have reverted");
1537     }
1538 }