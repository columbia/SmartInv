1 pragma solidity 0.8.9;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return payable(msg.sender);
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     function allowance(address owner, address spender)
24         external
25         view
26         returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(
57         uint256 a,
58         uint256 b,
59         string memory errorMessage
60     ) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         return mod(a, b, "SafeMath: modulo by zero");
96     }
97 
98     function mod(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b != 0, errorMessage);
104         return a % b;
105     }
106 }
107 
108 library Address {
109     function isContract(address account) internal view returns (bool) {
110         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
111         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
112         // for accounts without code, i.e. `keccak256('')`
113         bytes32 codehash;
114         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
115         // solhint-disable-next-line no-inline-assembly
116         assembly {
117             codehash := extcodehash(account)
118         }
119         return (codehash != accountHash && codehash != 0x0);
120     }
121 
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(
124             address(this).balance >= amount,
125             "Address: insufficient balance"
126         );
127 
128         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
129         (bool success, ) = recipient.call{value: amount}("");
130         require(
131             success,
132             "Address: unable to send value, recipient may have reverted"
133         );
134     }
135 
136     function functionCall(address target, bytes memory data)
137         internal
138         returns (bytes memory)
139     {
140         return functionCall(target, data, "Address: low-level call failed");
141     }
142 
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return _functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value
155     ) internal returns (bytes memory) {
156         return
157             functionCallWithValue(
158                 target,
159                 data,
160                 value,
161                 "Address: low-level call with value failed"
162             );
163     }
164 
165     function functionCallWithValue(
166         address target,
167         bytes memory data,
168         uint256 value,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         require(
172             address(this).balance >= value,
173             "Address: insufficient balance for call"
174         );
175         return _functionCallWithValue(target, data, value, errorMessage);
176     }
177 
178     function _functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 weiValue,
182         string memory errorMessage
183     ) private returns (bytes memory) {
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: weiValue}(
187             data
188         );
189         if (success) {
190             return returndata;
191         } else {
192             if (returndata.length > 0) {
193                 assembly {
194                     let returndata_size := mload(returndata)
195                     revert(add(32, returndata), returndata_size)
196                 }
197             } else {
198                 revert(errorMessage);
199             }
200         }
201     }
202 }
203 
204 contract Ownable is Context {
205     address private _owner;
206     address private _previousOwner;
207     uint256 private _lockTime;
208 
209     event OwnershipTransferred(
210         address indexed previousOwner,
211         address indexed newOwner
212     );
213 
214     constructor() {
215         address msgSender = _msgSender();
216         _owner = msgSender;
217         emit OwnershipTransferred(address(0), msgSender);
218     }
219 
220     function owner() public view returns (address) {
221         return _owner;
222     }
223 
224     modifier onlyOwner() {
225         require(_owner == _msgSender(), "Ownable: caller is not the owner");
226         _;
227     }
228 
229     function renounceOwnership() public virtual onlyOwner {
230         emit OwnershipTransferred(_owner, address(0));
231         _owner = address(0);
232     }
233 
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(
236             newOwner != address(0),
237             "Ownable: new owner is the zero address"
238         );
239         emit OwnershipTransferred(_owner, newOwner);
240         _owner = newOwner;
241     }
242 
243     function getUnlockTime() public view returns (uint256) {
244         return _lockTime;
245     }
246 
247     function getTime() public view returns (uint256) {
248         return block.timestamp;
249     }
250 }
251 
252 
253 interface IUniswapV2Factory {
254     event PairCreated(
255         address indexed token0,
256         address indexed token1,
257         address pair,
258         uint256
259     );
260 
261     function feeTo() external view returns (address);
262 
263     function feeToSetter() external view returns (address);
264 
265     function getPair(address tokenA, address tokenB)
266         external
267         view
268         returns (address pair);
269 
270     function allPairs(uint256) external view returns (address pair);
271 
272     function allPairsLength() external view returns (uint256);
273 
274     function createPair(address tokenA, address tokenB)
275         external
276         returns (address pair);
277 
278     function setFeeTo(address) external;
279 
280     function setFeeToSetter(address) external;
281 }
282 
283 
284 interface IUniswapV2Pair {
285     event Approval(
286         address indexed owner,
287         address indexed spender,
288         uint256 value
289     );
290     event Transfer(address indexed from, address indexed to, uint256 value);
291 
292     function name() external pure returns (string memory);
293 
294     function symbol() external pure returns (string memory);
295 
296     function decimals() external pure returns (uint8);
297 
298     function totalSupply() external view returns (uint256);
299 
300     function balanceOf(address owner) external view returns (uint256);
301 
302     function allowance(address owner, address spender)
303         external
304         view
305         returns (uint256);
306 
307     function approve(address spender, uint256 value) external returns (bool);
308 
309     function transfer(address to, uint256 value) external returns (bool);
310 
311     function transferFrom(
312         address from,
313         address to,
314         uint256 value
315     ) external returns (bool);
316 
317     function DOMAIN_SEPARATOR() external view returns (bytes32);
318 
319     function PERMIT_TYPEHASH() external pure returns (bytes32);
320 
321     function nonces(address owner) external view returns (uint256);
322 
323     function permit(
324         address owner,
325         address spender,
326         uint256 value,
327         uint256 deadline,
328         uint8 v,
329         bytes32 r,
330         bytes32 s
331     ) external;
332 
333     event Burn(
334         address indexed sender,
335         uint256 amount0,
336         uint256 amount1,
337         address indexed to
338     );
339     event Swap(
340         address indexed sender,
341         uint256 amount0In,
342         uint256 amount1In,
343         uint256 amount0Out,
344         uint256 amount1Out,
345         address indexed to
346     );
347     event Sync(uint112 reserve0, uint112 reserve1);
348 
349     function MINIMUM_LIQUIDITY() external pure returns (uint256);
350 
351     function factory() external view returns (address);
352 
353     function token0() external view returns (address);
354 
355     function token1() external view returns (address);
356 
357     function getReserves()
358         external
359         view
360         returns (
361             uint112 reserve0,
362             uint112 reserve1,
363             uint32 blockTimestampLast
364         );
365 
366     function price0CumulativeLast() external view returns (uint256);
367 
368     function price1CumulativeLast() external view returns (uint256);
369 
370     function kLast() external view returns (uint256);
371 
372     function burn(address to)
373         external
374         returns (uint256 amount0, uint256 amount1);
375 
376     function swap(
377         uint256 amount0Out,
378         uint256 amount1Out,
379         address to,
380         bytes calldata data
381     ) external;
382 
383     function skim(address to) external;
384 
385     function sync() external;
386 
387     function initialize(address, address) external;
388 }
389 
390 interface IUniswapV2Router01 {
391     function factory() external pure returns (address);
392 
393     function WETH() external pure returns (address);
394 
395     function addLiquidity(
396         address tokenA,
397         address tokenB,
398         uint256 amountADesired,
399         uint256 amountBDesired,
400         uint256 amountAMin,
401         uint256 amountBMin,
402         address to,
403         uint256 deadline
404     )
405         external
406         returns (
407             uint256 amountA,
408             uint256 amountB,
409             uint256 liquidity
410         );
411 
412     function addLiquidityETH(
413         address token,
414         uint256 amountTokenDesired,
415         uint256 amountTokenMin,
416         uint256 amountETHMin,
417         address to,
418         uint256 deadline
419     )
420         external
421         payable
422         returns (
423             uint256 amountToken,
424             uint256 amountETH,
425             uint256 liquidity
426         );
427 
428     function removeLiquidity(
429         address tokenA,
430         address tokenB,
431         uint256 liquidity,
432         uint256 amountAMin,
433         uint256 amountBMin,
434         address to,
435         uint256 deadline
436     ) external returns (uint256 amountA, uint256 amountB);
437 
438     function removeLiquidityETH(
439         address token,
440         uint256 liquidity,
441         uint256 amountTokenMin,
442         uint256 amountETHMin,
443         address to,
444         uint256 deadline
445     ) external returns (uint256 amountToken, uint256 amountETH);
446 
447     function removeLiquidityWithPermit(
448         address tokenA,
449         address tokenB,
450         uint256 liquidity,
451         uint256 amountAMin,
452         uint256 amountBMin,
453         address to,
454         uint256 deadline,
455         bool approveMax,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) external returns (uint256 amountA, uint256 amountB);
460 
461     function removeLiquidityETHWithPermit(
462         address token,
463         uint256 liquidity,
464         uint256 amountTokenMin,
465         uint256 amountETHMin,
466         address to,
467         uint256 deadline,
468         bool approveMax,
469         uint8 v,
470         bytes32 r,
471         bytes32 s
472     ) external returns (uint256 amountToken, uint256 amountETH);
473 
474     function swapExactTokensForTokens(
475         uint256 amountIn,
476         uint256 amountOutMin,
477         address[] calldata path,
478         address to,
479         uint256 deadline
480     ) external returns (uint256[] memory amounts);
481 
482     function swapTokensForExactTokens(
483         uint256 amountOut,
484         uint256 amountInMax,
485         address[] calldata path,
486         address to,
487         uint256 deadline
488     ) external returns (uint256[] memory amounts);
489 
490     function swapExactETHForTokens(
491         uint256 amountOutMin,
492         address[] calldata path,
493         address to,
494         uint256 deadline
495     ) external payable returns (uint256[] memory amounts);
496 
497     function swapTokensForExactETH(
498         uint256 amountOut,
499         uint256 amountInMax,
500         address[] calldata path,
501         address to,
502         uint256 deadline
503     ) external returns (uint256[] memory amounts);
504 
505     function swapExactTokensForETH(
506         uint256 amountIn,
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external returns (uint256[] memory amounts);
512 
513     function swapETHForExactTokens(
514         uint256 amountOut,
515         address[] calldata path,
516         address to,
517         uint256 deadline
518     ) external payable returns (uint256[] memory amounts);
519 
520     function quote(
521         uint256 amountA,
522         uint256 reserveA,
523         uint256 reserveB
524     ) external pure returns (uint256 amountB);
525 
526     function getAmountOut(
527         uint256 amountIn,
528         uint256 reserveIn,
529         uint256 reserveOut
530     ) external pure returns (uint256 amountOut);
531 
532     function getAmountIn(
533         uint256 amountOut,
534         uint256 reserveIn,
535         uint256 reserveOut
536     ) external pure returns (uint256 amountIn);
537 
538     function getAmountsOut(uint256 amountIn, address[] calldata path)
539         external
540         view
541         returns (uint256[] memory amounts);
542 
543     function getAmountsIn(uint256 amountOut, address[] calldata path)
544         external
545         view
546         returns (uint256[] memory amounts);
547 }
548 
549 interface IUniswapV2Router02 is IUniswapV2Router01 {
550     function removeLiquidityETHSupportingFeeOnTransferTokens(
551         address token,
552         uint256 liquidity,
553         uint256 amountTokenMin,
554         uint256 amountETHMin,
555         address to,
556         uint256 deadline
557     ) external returns (uint256 amountETH);
558 
559     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
560         address token,
561         uint256 liquidity,
562         uint256 amountTokenMin,
563         uint256 amountETHMin,
564         address to,
565         uint256 deadline,
566         bool approveMax,
567         uint8 v,
568         bytes32 r,
569         bytes32 s
570     ) external returns (uint256 amountETH);
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
596 contract AnySniper is Context, IERC20, Ownable {
597     using SafeMath for uint256;
598     using Address for address;
599 
600     address payable public marketingAddress = payable(0x960E8ec2b53505bD6751e7673e1d44E5ec33E57a); // Marketing Address
601     address payable public rewardAddress = payable(0x960E8ec2b53505bD6751e7673e1d44E5ec33E57a); // Reward Address
602     address payable public liquidityAddress = payable(0x960E8ec2b53505bD6751e7673e1d44E5ec33E57a); // Liquidity Address
603 
604     mapping(address => uint256) private _rOwned;
605     mapping(address => uint256) private _tOwned;
606     mapping(address => mapping(address => uint256)) private _allowances;
607 
608     mapping(address => bool) private _isExcludedFromFee;
609 
610     mapping(address => bool) private _isExcluded;
611     address[] private _excluded;
612 
613     uint256 private constant MAX = ~uint256(0);
614     uint256 private constant _tTotal = 1 * 1e9 * 1e18;
615     uint256 private _rTotal = (MAX - (MAX % _tTotal));
616     uint256 private _tFeeTotal;
617 
618     string private constant _name = "AnySniper";
619     string private constant _symbol = "SNIPE";
620     uint8 private constant _decimals = 18;
621 
622     uint256 private constant BUY = 1;
623     uint256 private constant SELL = 2;
624     uint256 private constant TRANSFER = 3;
625     uint256 private buyOrSellSwitch;
626 
627     uint256 public manualBurnFrequency = 30 minutes;
628     uint256 public lastManualLpBurnTime;
629 
630     uint256 private _taxFee;
631     uint256 private _previousTaxFee = _taxFee;
632 
633     uint256 private _liquidityFee;
634     uint256 private _previousLiquidityFee = _liquidityFee;
635 
636     uint256 public _buyTaxFee;
637     uint256 public _buyLiquidityFee = 3;
638     uint256 public _buyRewardFee;
639     uint256 public _buyMarketingFee = 9;
640 
641     uint256 public _sellTaxFee;
642     uint256 public _sellLiquidityFee = 3;
643     uint256 public _sellRewardFee;
644     uint256 public _sellMarketingFee = 9;
645 
646     uint256 public liquidityActiveBlock; // 0 means liquidity is not active yet
647     uint256 public tradingActiveBlock; // 0 means trading is not active
648     uint256 public deadBlocks;
649 
650     bool public limitsInEffect = true;
651     bool public tradingActive = false;
652     bool public swapEnabled = false;
653 
654     mapping (address => bool) public _isExcludedMaxTransactionAmount;
655 
656      // Anti-bot and anti-whale mappings and variables
657     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
658     bool public transferDelayEnabled = true;
659 
660     uint256 private _liquidityTokensToSwap;
661     uint256 private _rewardTokens;
662     uint256 private _marketingTokensToSwap;
663 
664     bool private gasLimitActive = true;
665     uint256 private gasPriceLimit = 602 * 1 gwei;
666 
667     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
668     // could be subject to a maximum transfer amount
669     mapping (address => bool) public automatedMarketMakerPairs;
670     mapping (address => bool) private _isSniper;
671 
672     uint256 public minimumTokensBeforeSwap;
673     uint256 public maxTransactionAmount;
674     uint256 public maxWallet;
675 
676     IUniswapV2Router02 public uniswapV2Router;
677     address public uniswapV2Pair;
678 
679     bool inSwapAndLiquify;
680     bool public swapAndLiquifyEnabled = false;
681 
682     event RewardLiquidityProviders(uint256 tokenAmount);
683     event SwapAndLiquifyEnabledUpdated(bool enabled);
684     event SwapAndLiquify(
685         uint256 tokensSwapped,
686         uint256 ethReceived,
687         uint256 tokensIntoLiqudity
688     );
689 
690     event SwapETHForTokens(uint256 amountIn, address[] path);
691 
692     event SwapTokensForETH(uint256 amountIn, address[] path);
693 
694     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
695 
696     event ManualBurnLP();
697 
698     modifier lockTheSwap() {
699         inSwapAndLiquify = true;
700         _;
701         inSwapAndLiquify = false;
702     }
703 
704     constructor() {
705         address newOwner = msg.sender; // update if auto-deploying to a different wallet        
706 
707         deadBlocks = 2;
708 
709         maxTransactionAmount = _tTotal * 50 / 10000; // 0.5% max txn
710         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
711         maxWallet = _tTotal * 100 / 10000; // 1%
712 
713         _rOwned[newOwner] = _rTotal;
714 
715         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
716             // ROPSTEN or HARDHAT
717             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
718         );
719 
720         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
721             .createPair(address(this), _uniswapV2Router.WETH());
722 
723         uniswapV2Router = _uniswapV2Router;
724         uniswapV2Pair = _uniswapV2Pair;
725 
726         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
727 
728         _isExcludedFromFee[newOwner] = true;
729         _isExcludedFromFee[address(this)] = true;
730         _isExcludedFromFee[liquidityAddress] = true;
731 
732         excludeFromMaxTransaction(newOwner, true);
733         excludeFromMaxTransaction(address(this), true);
734         excludeFromMaxTransaction(address(_uniswapV2Router), true);
735         excludeFromMaxTransaction(address(0xdead), true);
736 
737         emit Transfer(address(0), newOwner, _tTotal);
738     }
739 
740     function name() external pure returns (string memory) {
741         return _name;
742     }
743 
744     function symbol() external pure returns (string memory) {
745         return _symbol;
746     }
747 
748     function decimals() external pure returns (uint8) {
749         return _decimals;
750     }
751 
752     function totalSupply() external pure override returns (uint256) {
753         return _tTotal;
754     }
755 
756     function balanceOf(address account) public view override returns (uint256) {
757         if (_isExcluded[account]) return _tOwned[account];
758         return tokenFromReflection(_rOwned[account]);
759     }
760 
761     function transfer(address recipient, uint256 amount)
762         external
763         override
764         returns (bool)
765     {
766         _transfer(_msgSender(), recipient, amount);
767         return true;
768     }
769 
770     function allowance(address owner, address spender)
771         external
772         view
773         override
774         returns (uint256)
775     {
776         return _allowances[owner][spender];
777     }
778 
779     function approve(address spender, uint256 amount)
780         public
781         override
782         returns (bool)
783     {
784         _approve(_msgSender(), spender, amount);
785         return true;
786     }
787 
788     function transferFrom(
789         address sender,
790         address recipient,
791         uint256 amount
792     ) external override returns (bool) {
793         _transfer(sender, recipient, amount);
794         _approve(
795             sender,
796             _msgSender(),
797             _allowances[sender][_msgSender()].sub(
798                 amount,
799                 "ERC20: transfer amount exceeds allowance"
800             )
801         );
802         return true;
803     }
804 
805     function increaseAllowance(address spender, uint256 addedValue)
806         external
807         virtual
808         returns (bool)
809     {
810         _approve(
811             _msgSender(),
812             spender,
813             _allowances[_msgSender()][spender].add(addedValue)
814         );
815         return true;
816     }
817 
818     function decreaseAllowance(address spender, uint256 subtractedValue)
819         external
820         virtual
821         returns (bool)
822     {
823         _approve(
824             _msgSender(),
825             spender,
826             _allowances[_msgSender()][spender].sub(
827                 subtractedValue,
828                 "ERC20: decreased allowance below zero"
829             )
830         );
831         return true;
832     }
833 
834     function isExcludedFromReward(address account)
835         external
836         view
837         returns (bool)
838     {
839         return _isExcluded[account];
840     }
841 
842     function totalFees() external view returns (uint256) {
843         return _tFeeTotal;
844     }
845 
846     // once enabled, can never be turned off
847     function enableTrading(uint256 _deadBlocks) external onlyOwner {
848         tradingActive = true;
849         swapAndLiquifyEnabled = true;
850         tradingActiveBlock = block.number;
851         deadBlocks = _deadBlocks;
852     }
853 
854     function isSniper(address account) public view returns (bool) {
855         return _isSniper[account];
856     }
857     
858     function manageSnipers(address[] calldata addresses, bool status) public onlyOwner {
859         for (uint256 i; i < addresses.length; ++i) {
860             _isSniper[addresses[i]] = status;
861         }
862     }
863 
864     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
865         return minimumTokensBeforeSwap;
866     }
867 
868     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
869         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
870 
871         _setAutomatedMarketMakerPair(pair, value);
872     }
873 
874     function _setAutomatedMarketMakerPair(address pair, bool value) private {
875         automatedMarketMakerPairs[pair] = value;
876 
877         excludeFromMaxTransaction(pair, value);
878         if(value){excludeFromReward(pair);}
879         if(!value){includeInReward(pair);}
880     }
881 
882     function setProtectionSettings(bool antiGas) external onlyOwner() {
883         gasLimitActive = antiGas;
884     }
885 
886     function setGasPriceLimit(uint256 gas) external onlyOwner {
887         require(gas >= 300);
888         gasPriceLimit = gas * 1 gwei;
889     }
890 
891     // disable Transfer delay
892     function disableTransferDelay() external onlyOwner returns (bool){
893         transferDelayEnabled = false;
894         return true;
895     }
896 
897     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
898         external
899         view
900         returns (uint256)
901     {
902         require(tAmount <= _tTotal, "Amount must be less than supply");
903         if (!deductTransferFee) {
904             (uint256 rAmount, , , , , ) = _getValues(tAmount);
905             return rAmount;
906         } else {
907             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
908             return rTransferAmount;
909         }
910     }
911 
912     // for one-time airdrop feature after contract launch
913     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
914         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
915         removeAllFee();
916         buyOrSellSwitch = TRANSFER;
917         for(uint256 i = 0; i < airdropWallets.length; i++){
918             address wallet = airdropWallets[i];
919             uint256 airdropAmount = amount[i];
920             _tokenTransfer(msg.sender, wallet, airdropAmount);
921         }
922         restoreAllFee();
923     }
924 
925     // remove limits after token is stable - 30-60 minutes
926     function removeLimits() external onlyOwner returns (bool){
927         limitsInEffect = false;
928         gasLimitActive = false;
929         transferDelayEnabled = false;
930         return true;
931     }
932 
933     function tokenFromReflection(uint256 rAmount)
934         public
935         view
936         returns (uint256)
937     {
938         require(
939             rAmount <= _rTotal,
940             "Amount must be less than total reflections"
941         );
942         uint256 currentRate = _getRate();
943         return rAmount.div(currentRate);
944     }
945 
946     function excludeFromReward(address account) public onlyOwner {
947         require(!_isExcluded[account], "Account is already excluded");
948         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
949         if (_rOwned[account] > 0) {
950             _tOwned[account] = tokenFromReflection(_rOwned[account]);
951         }
952         _isExcluded[account] = true;
953         _excluded.push(account);
954     }
955 
956     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
957         _isExcludedMaxTransactionAmount[updAds] = isEx;
958         emit ExcludedMaxTransactionAmount(updAds, isEx);
959     }
960 
961     function includeInReward(address account) public onlyOwner {
962         require(_isExcluded[account], "Account is not excluded");
963         for (uint256 i = 0; i < _excluded.length; i++) {
964             if (_excluded[i] == account) {
965                 _excluded[i] = _excluded[_excluded.length - 1];
966                 _tOwned[account] = 0;
967                 _isExcluded[account] = false;
968                 _excluded.pop();
969                 break;
970             }
971         }
972     }
973 
974     function _approve(
975         address owner,
976         address spender,
977         uint256 amount
978     ) private {
979         require(owner != address(0), "ERC20: approve from the zero address");
980         require(spender != address(0), "ERC20: approve to the zero address");
981 
982         _allowances[owner][spender] = amount;
983         emit Approval(owner, spender, amount);
984     }
985 
986     function _transfer(
987         address from,
988         address to,
989         uint256 amount
990     ) private {
991         require(from != address(0), "ERC20: transfer from the zero address");
992         require(to != address(0), "ERC20: transfer to the zero address");
993         // require(!_isSniper[to], "You have no power here!");
994         // require(!_isSniper[from], "You have no power here!");
995         require(amount > 0, "Transfer amount must be greater than zero");
996 
997         if(limitsInEffect){
998             if (
999                 from != owner() &&
1000                 to != owner() &&
1001                 to != address(0) &&
1002                 to != address(0xdead) &&
1003                 !inSwapAndLiquify
1004             ){
1005 
1006                 if(!tradingActive || (tradingActiveBlock > 0 && tradingActiveBlock + deadBlocks > block.number)){
1007                     _isSniper[to] = true;
1008                 }
1009 
1010                 // only use to prevent sniper buys in the first blocks.
1011                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1012                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1013                 }
1014 
1015                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1016                 if (transferDelayEnabled){
1017                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1018                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1019                         _holderLastTransferTimestamp[tx.origin] = block.number;
1020                     }
1021                 }
1022 
1023                 //when buy
1024                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1025                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1026                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1027                 }
1028                 //when sell
1029                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1030                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1031                 }
1032                 else if (!_isExcludedMaxTransactionAmount[to]){
1033                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1034                 }
1035             }
1036         }
1037 
1038         uint256 contractTokenBalance = balanceOf(address(this));
1039         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1040 
1041         // Sell tokens for ETH
1042         if (
1043             !inSwapAndLiquify &&
1044             swapAndLiquifyEnabled &&
1045             balanceOf(uniswapV2Pair) > 0 &&
1046             overMinimumTokenBalance &&
1047             automatedMarketMakerPairs[to]
1048         ) {
1049             swapBack();
1050         }
1051 
1052         removeAllFee();
1053 
1054         buyOrSellSwitch = TRANSFER;
1055 
1056         // If any account belongs to _isExcludedFromFee account then remove the fee
1057         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1058             // Buy
1059             if (automatedMarketMakerPairs[from]) {
1060                 _taxFee = _buyTaxFee;
1061                 _liquidityFee = _buyLiquidityFee + _buyRewardFee + _buyMarketingFee;
1062                 if(_liquidityFee > 0){
1063                     buyOrSellSwitch = BUY;
1064                 }
1065             }
1066             // Sell
1067             else if (automatedMarketMakerPairs[to]) {
1068                 _taxFee = _sellTaxFee;
1069                 _liquidityFee = _sellLiquidityFee + _sellRewardFee + _sellMarketingFee;
1070                 if(_liquidityFee > 0){
1071                     buyOrSellSwitch = SELL;
1072                 }
1073             }
1074 
1075             // If sniper buy or sell, increase marketing fee
1076             if ((_isSniper[to] || _isSniper[from]) && _liquidityFee > 0) {
1077                 _liquidityFee = 99;
1078             }
1079         }
1080 
1081         _tokenTransfer(from, to, amount);
1082 
1083         restoreAllFee();
1084 
1085     }
1086     
1087     // change the minimum amount of tokens to sell from fees
1088     function updateSwapTokensAtPercent(uint256 percent) external onlyOwner returns (bool){
1089   	    require(percent >= 1, "Swap amount cannot be lower than 0.001% total supply.");
1090   	    require(percent <= 50, "Swap amount cannot be higher than 0.5% total supply.");
1091   	    minimumTokensBeforeSwap = _tTotal * percent / 10000;
1092   	    return true;
1093   	}
1094 
1095     function updateMaxTxnPercent(uint256 percent) external onlyOwner {
1096         require(percent >= 10, "Cannot set maxTransactionAmount lower than 0.1%");
1097         maxTransactionAmount = _tTotal * percent / 10000;
1098     }
1099 
1100     // percent 25 for .25%
1101     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1102         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1103         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1104         lastManualLpBurnTime = block.timestamp;
1105         
1106         // get balance of liquidity pair
1107         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1108         
1109         // calculate amount to burn
1110         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1111         
1112         // pull tokens from pancakePair liquidity and move to dead address permanently
1113         if (amountToBurn > 0){
1114             _transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1115         }
1116         
1117         //sync price since this is not in a swap transaction!
1118         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1119         pair.sync();
1120         emit ManualBurnLP();
1121         return true;
1122     }
1123 
1124     function swapBack() private lockTheSwap {
1125         uint256 contractBalance = balanceOf(address(this));
1126         bool success;
1127         uint256 totalTokensToSwap = _liquidityTokensToSwap + _rewardTokens + _marketingTokensToSwap;
1128         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1129 
1130         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1131         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity).sub(_rewardTokens);
1132 
1133         uint256 initialETHBalance = address(this).balance;
1134 
1135         swapTokensForETH(amountToSwapForETH);
1136 
1137         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1138 
1139         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1140 
1141         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1142 
1143         // Transfer rewards token to reward wallet
1144         uint256 currentRate = _getRate();
1145         uint256 rReward = _rewardTokens.mul(currentRate);
1146         _rOwned[address(rewardAddress)] = _rOwned[address(rewardAddress)].add(rReward);
1147         _tOwned[address(rewardAddress)] = _tOwned[address(rewardAddress)].add(_rewardTokens);
1148 
1149         _liquidityTokensToSwap = 0;
1150         _rewardTokens = 0;
1151         _marketingTokensToSwap = 0;
1152 
1153         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
1154             addLiquidity(tokensForLiquidity, ethForLiquidity);
1155             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1156         }
1157 
1158         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1159 
1160     }
1161 
1162     function swapTokensForETH(uint256 tokenAmount) private {
1163         address[] memory path = new address[](2);
1164         path[0] = address(this);
1165         path[1] = uniswapV2Router.WETH();
1166         _approve(address(this), address(uniswapV2Router), tokenAmount);
1167         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1168             tokenAmount,
1169             0, // accept any amount of ETH
1170             path,
1171             address(this),
1172             block.timestamp
1173         );
1174     }
1175 
1176     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1177         _approve(address(this), address(uniswapV2Router), tokenAmount);
1178         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1179             address(this),
1180             tokenAmount,
1181             0, // slippage is unavoidable
1182             0, // slippage is unavoidable
1183             liquidityAddress,
1184             block.timestamp
1185         );
1186     }
1187 
1188     function _tokenTransfer(
1189         address sender,
1190         address recipient,
1191         uint256 amount
1192     ) private {
1193 
1194         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1195             _transferFromExcluded(sender, recipient, amount);
1196         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1197             _transferToExcluded(sender, recipient, amount);
1198         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1199             _transferBothExcluded(sender, recipient, amount);
1200         } else {
1201             _transferStandard(sender, recipient, amount);
1202         }
1203     }
1204 
1205     function _transferStandard(
1206         address sender,
1207         address recipient,
1208         uint256 tAmount
1209     ) private {
1210         (
1211             uint256 rAmount,
1212             uint256 rTransferAmount,
1213             uint256 rFee,
1214             uint256 tTransferAmount,
1215             uint256 tFee,
1216             uint256 tLiquidity
1217         ) = _getValues(tAmount);
1218         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1219         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1220         _takeLiquidity(tLiquidity);
1221         _reflectFee(rFee, tFee);
1222         emit Transfer(sender, recipient, tTransferAmount);
1223     }
1224 
1225     function _transferToExcluded(
1226         address sender,
1227         address recipient,
1228         uint256 tAmount
1229     ) private {
1230         (
1231             uint256 rAmount,
1232             uint256 rTransferAmount,
1233             uint256 rFee,
1234             uint256 tTransferAmount,
1235             uint256 tFee,
1236             uint256 tLiquidity
1237         ) = _getValues(tAmount);
1238         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1239         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1240         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1241         _takeLiquidity(tLiquidity);
1242         _reflectFee(rFee, tFee);
1243         emit Transfer(sender, recipient, tTransferAmount);
1244     }
1245 
1246     function _transferFromExcluded(
1247         address sender,
1248         address recipient,
1249         uint256 tAmount
1250     ) private {
1251         (
1252             uint256 rAmount,
1253             uint256 rTransferAmount,
1254             uint256 rFee,
1255             uint256 tTransferAmount,
1256             uint256 tFee,
1257             uint256 tLiquidity
1258         ) = _getValues(tAmount);
1259         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1260         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1261         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1262         _takeLiquidity(tLiquidity);
1263         _reflectFee(rFee, tFee);
1264         emit Transfer(sender, recipient, tTransferAmount);
1265     }
1266 
1267     function _transferBothExcluded(
1268         address sender,
1269         address recipient,
1270         uint256 tAmount
1271     ) private {
1272         (
1273             uint256 rAmount,
1274             uint256 rTransferAmount,
1275             uint256 rFee,
1276             uint256 tTransferAmount,
1277             uint256 tFee,
1278             uint256 tLiquidity
1279         ) = _getValues(tAmount);
1280         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1281         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1282         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1283         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1284         _takeLiquidity(tLiquidity);
1285         _reflectFee(rFee, tFee);
1286         emit Transfer(sender, recipient, tTransferAmount);
1287     }
1288 
1289     function _reflectFee(uint256 rFee, uint256 tFee) private {
1290         _rTotal = _rTotal.sub(rFee);
1291         _tFeeTotal = _tFeeTotal.add(tFee);
1292     }
1293 
1294     function _getValues(uint256 tAmount)
1295         private
1296         view
1297         returns (
1298             uint256,
1299             uint256,
1300             uint256,
1301             uint256,
1302             uint256,
1303             uint256
1304         )
1305     {
1306         (
1307             uint256 tTransferAmount,
1308             uint256 tFee,
1309             uint256 tLiquidity
1310         ) = _getTValues(tAmount);
1311         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1312             tAmount,
1313             tFee,
1314             tLiquidity,
1315             _getRate()
1316         );
1317         return (
1318             rAmount,
1319             rTransferAmount,
1320             rFee,
1321             tTransferAmount,
1322             tFee,
1323             tLiquidity
1324         );
1325     }
1326 
1327     function _getTValues(uint256 tAmount)
1328         private
1329         view
1330         returns (
1331             uint256,
1332             uint256,
1333             uint256
1334         )
1335     {
1336         uint256 tFee = calculateTaxFee(tAmount);
1337         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1339         return (tTransferAmount, tFee, tLiquidity);
1340     }
1341 
1342     function _getRValues(
1343         uint256 tAmount,
1344         uint256 tFee,
1345         uint256 tLiquidity,
1346         uint256 currentRate
1347     )
1348         private
1349         pure
1350         returns (
1351             uint256,
1352             uint256,
1353             uint256
1354         )
1355     {
1356         uint256 rAmount = tAmount.mul(currentRate);
1357         uint256 rFee = tFee.mul(currentRate);
1358         uint256 rLiquidity = tLiquidity.mul(currentRate);
1359         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1360         return (rAmount, rTransferAmount, rFee);
1361     }
1362 
1363     function _getRate() private view returns (uint256) {
1364         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1365         return rSupply.div(tSupply);
1366     }
1367 
1368     function _getCurrentSupply() private view returns (uint256, uint256) {
1369         uint256 rSupply = _rTotal;
1370         uint256 tSupply = _tTotal;
1371         for (uint256 i = 0; i < _excluded.length; i++) {
1372             if (
1373                 _rOwned[_excluded[i]] > rSupply ||
1374                 _tOwned[_excluded[i]] > tSupply
1375             ) return (_rTotal, _tTotal);
1376             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1377             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1378         }
1379         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1380         return (rSupply, tSupply);
1381     }
1382 
1383     function _takeLiquidity(uint256 tLiquidity) private {
1384         if(buyOrSellSwitch == BUY){
1385             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1386             _rewardTokens += tLiquidity * _buyRewardFee / _liquidityFee;
1387             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1388         } else if(buyOrSellSwitch == SELL){
1389             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1390             _rewardTokens += tLiquidity * _sellRewardFee / _liquidityFee;
1391             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1392         }
1393         
1394         uint256 currentRate = _getRate();
1395         uint256 rLiquidity = tLiquidity.mul(currentRate);
1396         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1397         if (_isExcluded[address(this)])
1398             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1399     }
1400 
1401     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1402         return _amount.mul(_taxFee).div(10**2);
1403     }
1404 
1405     function calculateLiquidityFee(uint256 _amount)
1406         private
1407         view
1408         returns (uint256)
1409     {
1410         return _amount.mul(_liquidityFee).div(10**2);
1411     }
1412 
1413     function removeAllFee() private {
1414         if (_taxFee == 0 && _liquidityFee == 0) return;
1415 
1416         _previousTaxFee = _taxFee;
1417         _previousLiquidityFee = _liquidityFee;
1418 
1419         _taxFee = 0;
1420         _liquidityFee = 0;
1421     }
1422 
1423     function restoreAllFee() private {
1424         _taxFee = _previousTaxFee;
1425         _liquidityFee = _previousLiquidityFee;
1426     }
1427 
1428     function isExcludedFromFee(address account) external view returns (bool) {
1429         return _isExcludedFromFee[account];
1430     }
1431 
1432     function excludeFromFee(address account) external onlyOwner {
1433         _isExcludedFromFee[account] = true;
1434     }
1435 
1436     function includeInFee(address account) external onlyOwner {
1437         _isExcludedFromFee[account] = false;
1438     }
1439 
1440     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyRewardFee, uint256 buyMarketingFee)
1441         external
1442         onlyOwner
1443     {
1444         _buyTaxFee = buyTaxFee;
1445         _buyLiquidityFee = buyLiquidityFee;
1446         _buyRewardFee = buyRewardFee;
1447         _buyMarketingFee = buyMarketingFee;
1448         require(_buyTaxFee + _buyLiquidityFee + _buyRewardFee + _buyMarketingFee <= 15, "Must keep taxes below 15%");
1449     }
1450 
1451     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellRewardFee, uint256 sellMarketingFee)
1452         external
1453         onlyOwner
1454     {
1455         _sellTaxFee = sellTaxFee;
1456         _sellLiquidityFee = sellLiquidityFee;
1457         _sellRewardFee = sellRewardFee;
1458         _sellMarketingFee = sellMarketingFee;
1459         require(_sellTaxFee + _sellLiquidityFee + _sellRewardFee + _sellMarketingFee <= 25, "Must keep taxes below 25%");
1460     }
1461 
1462     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1463         marketingAddress = payable(_marketingAddress);
1464         _isExcludedFromFee[marketingAddress] = true;
1465     }
1466 
1467     function setRewardAddress(address _rewardAddress) external onlyOwner {
1468         rewardAddress = payable(_rewardAddress);
1469         _isExcludedFromFee[rewardAddress] = true;
1470     }
1471 
1472     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1473         liquidityAddress = payable(_liquidityAddress);
1474         _isExcludedFromFee[liquidityAddress] = true;
1475     }
1476 
1477     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1478         swapAndLiquifyEnabled = _enabled;
1479         emit SwapAndLiquifyEnabledUpdated(_enabled);
1480     }
1481 
1482     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1483     function buyBackTokens(uint256 ethAmountInWei) external onlyOwner {
1484         // generate the uniswap pair path of weth -> eth
1485         address[] memory path = new address[](2);
1486         path[0] = uniswapV2Router.WETH();
1487         path[1] = address(this);
1488 
1489         // make the swap
1490         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1491             0, // accept any amount of Token
1492             path,
1493             address(0xdead),
1494             block.timestamp
1495         );
1496     }
1497 
1498     // To receive ETH from uniswapV2Router when swapping
1499     receive() external payable {}
1500 
1501     function transferForeignToken(address _token, address _to)
1502         external
1503         onlyOwner
1504         returns (bool _sent)
1505     {
1506         require(_token != address(this), "Can't withdraw native tokens");
1507         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1508         _sent = IERC20(_token).transfer(_to, _contractBalance);
1509     }
1510 
1511     function manualSend(address _recipient) external onlyOwner {
1512         uint256 contractETHBalance = address(this).balance;
1513         (bool success, ) = _recipient.call{ value: contractETHBalance }("");
1514         require(success, "Address: unable to send value, recipient may have reverted");
1515     }
1516 }