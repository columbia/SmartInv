1 /**
2 ░█▀▀▀█ ░█─░█ ░█▀▀█ 　 ░█▄─░█ ░█▀▀▀ ▀▀█▀▀ ░█──░█ ░█▀▀▀█ ░█▀▀█ ░█─▄▀ 
3 ─▀▀▀▄▄ ░█─░█ ░█▄▄█ 　 ░█░█░█ ░█▀▀▀ ─░█── ░█░█░█ ░█──░█ ░█▄▄▀ ░█▀▄─ 
4 ░█▄▄▄█ ─▀▄▄▀ ░█─── 　 ░█──▀█ ░█▄▄▄ ─░█── ░█▄▀▄█ ░█▄▄▄█ ░█─░█ ░█─░█
5 
6 Join SUP Network to make money doing what you love
7 
8 - Give your audience an easy way to say thanks
9 - Monthly membership for your biggest fans 
10 - Set a crowdfunding goal
11 - Take commission or request
12  
13 Connect with your inspirations like never before,
14 The only platform for creators to provide exclusive access to their content and to build a deeper connection with their communities
15 We are unique because we are the first platform to accept crypto payments. We allow members to utilize cryptocurrency as a way to build stronger connections.
16 
17 Website: https://sup.network
18 Telegram: https://t.me/sup_network
19 */
20 
21 pragma solidity 0.8.9;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return payable(msg.sender);
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address recipient, uint256 amount)
40         external
41         returns (bool);
42 
43     function allowance(address owner, address spender)
44         external
45         view
46         returns (uint256);
47 
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(
58         address indexed owner,
59         address indexed spender,
60         uint256 value
61     );
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     function div(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         return mod(a, b, "SafeMath: modulo by zero");
116     }
117 
118     function mod(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b != 0, errorMessage);
124         return a % b;
125     }
126 }
127 
128 library Address {
129     function isContract(address account) internal view returns (bool) {
130         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
131         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
132         // for accounts without code, i.e. `keccak256('')`
133         bytes32 codehash;
134         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
135         // solhint-disable-next-line no-inline-assembly
136         assembly {
137             codehash := extcodehash(account)
138         }
139         return (codehash != accountHash && codehash != 0x0);
140     }
141 
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(
144             address(this).balance >= amount,
145             "Address: insufficient balance"
146         );
147 
148         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
149         (bool success, ) = recipient.call{value: amount}("");
150         require(
151             success,
152             "Address: unable to send value, recipient may have reverted"
153         );
154     }
155 
156     function functionCall(address target, bytes memory data)
157         internal
158         returns (bytes memory)
159     {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return _functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value
175     ) internal returns (bytes memory) {
176         return
177             functionCallWithValue(
178                 target,
179                 data,
180                 value,
181                 "Address: low-level call with value failed"
182             );
183     }
184 
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(
192             address(this).balance >= value,
193             "Address: insufficient balance for call"
194         );
195         return _functionCallWithValue(target, data, value, errorMessage);
196     }
197 
198     function _functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 weiValue,
202         string memory errorMessage
203     ) private returns (bytes memory) {
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: weiValue}(
207             data
208         );
209         if (success) {
210             return returndata;
211         } else {
212             if (returndata.length > 0) {
213                 assembly {
214                     let returndata_size := mload(returndata)
215                     revert(add(32, returndata), returndata_size)
216                 }
217             } else {
218                 revert(errorMessage);
219             }
220         }
221     }
222 }
223 
224 contract Ownable is Context {
225     address private _owner;
226     address private _previousOwner;
227     uint256 private _lockTime;
228 
229     event OwnershipTransferred(
230         address indexed previousOwner,
231         address indexed newOwner
232     );
233 
234     constructor() {
235         address msgSender = _msgSender();
236         _owner = msgSender;
237         emit OwnershipTransferred(address(0), msgSender);
238     }
239 
240     function owner() public view returns (address) {
241         return _owner;
242     }
243 
244     modifier onlyOwner() {
245         require(_owner == _msgSender(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     function renounceOwnership() public virtual onlyOwner {
250         emit OwnershipTransferred(_owner, address(0));
251         _owner = address(0);
252     }
253 
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(
256             newOwner != address(0),
257             "Ownable: new owner is the zero address"
258         );
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 
263     function getUnlockTime() public view returns (uint256) {
264         return _lockTime;
265     }
266 
267     function getTime() public view returns (uint256) {
268         return block.timestamp;
269     }
270 }
271 
272 
273 interface IUniswapV2Factory {
274     event PairCreated(
275         address indexed token0,
276         address indexed token1,
277         address pair,
278         uint256
279     );
280 
281     function feeTo() external view returns (address);
282 
283     function feeToSetter() external view returns (address);
284 
285     function getPair(address tokenA, address tokenB)
286         external
287         view
288         returns (address pair);
289 
290     function allPairs(uint256) external view returns (address pair);
291 
292     function allPairsLength() external view returns (uint256);
293 
294     function createPair(address tokenA, address tokenB)
295         external
296         returns (address pair);
297 
298     function setFeeTo(address) external;
299 
300     function setFeeToSetter(address) external;
301 }
302 
303 
304 interface IUniswapV2Pair {
305     event Approval(
306         address indexed owner,
307         address indexed spender,
308         uint256 value
309     );
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     function name() external pure returns (string memory);
313 
314     function symbol() external pure returns (string memory);
315 
316     function decimals() external pure returns (uint8);
317 
318     function totalSupply() external view returns (uint256);
319 
320     function balanceOf(address owner) external view returns (uint256);
321 
322     function allowance(address owner, address spender)
323         external
324         view
325         returns (uint256);
326 
327     function approve(address spender, uint256 value) external returns (bool);
328 
329     function transfer(address to, uint256 value) external returns (bool);
330 
331     function transferFrom(
332         address from,
333         address to,
334         uint256 value
335     ) external returns (bool);
336 
337     function DOMAIN_SEPARATOR() external view returns (bytes32);
338 
339     function PERMIT_TYPEHASH() external pure returns (bytes32);
340 
341     function nonces(address owner) external view returns (uint256);
342 
343     function permit(
344         address owner,
345         address spender,
346         uint256 value,
347         uint256 deadline,
348         uint8 v,
349         bytes32 r,
350         bytes32 s
351     ) external;
352 
353     event Burn(
354         address indexed sender,
355         uint256 amount0,
356         uint256 amount1,
357         address indexed to
358     );
359     event Swap(
360         address indexed sender,
361         uint256 amount0In,
362         uint256 amount1In,
363         uint256 amount0Out,
364         uint256 amount1Out,
365         address indexed to
366     );
367     event Sync(uint112 reserve0, uint112 reserve1);
368 
369     function MINIMUM_LIQUIDITY() external pure returns (uint256);
370 
371     function factory() external view returns (address);
372 
373     function token0() external view returns (address);
374 
375     function token1() external view returns (address);
376 
377     function getReserves()
378         external
379         view
380         returns (
381             uint112 reserve0,
382             uint112 reserve1,
383             uint32 blockTimestampLast
384         );
385 
386     function price0CumulativeLast() external view returns (uint256);
387 
388     function price1CumulativeLast() external view returns (uint256);
389 
390     function kLast() external view returns (uint256);
391 
392     function burn(address to)
393         external
394         returns (uint256 amount0, uint256 amount1);
395 
396     function swap(
397         uint256 amount0Out,
398         uint256 amount1Out,
399         address to,
400         bytes calldata data
401     ) external;
402 
403     function skim(address to) external;
404 
405     function sync() external;
406 
407     function initialize(address, address) external;
408 }
409 
410 interface IUniswapV2Router01 {
411     function factory() external pure returns (address);
412 
413     function WETH() external pure returns (address);
414 
415     function addLiquidity(
416         address tokenA,
417         address tokenB,
418         uint256 amountADesired,
419         uint256 amountBDesired,
420         uint256 amountAMin,
421         uint256 amountBMin,
422         address to,
423         uint256 deadline
424     )
425         external
426         returns (
427             uint256 amountA,
428             uint256 amountB,
429             uint256 liquidity
430         );
431 
432     function addLiquidityETH(
433         address token,
434         uint256 amountTokenDesired,
435         uint256 amountTokenMin,
436         uint256 amountETHMin,
437         address to,
438         uint256 deadline
439     )
440         external
441         payable
442         returns (
443             uint256 amountToken,
444             uint256 amountETH,
445             uint256 liquidity
446         );
447 
448     function removeLiquidity(
449         address tokenA,
450         address tokenB,
451         uint256 liquidity,
452         uint256 amountAMin,
453         uint256 amountBMin,
454         address to,
455         uint256 deadline
456     ) external returns (uint256 amountA, uint256 amountB);
457 
458     function removeLiquidityETH(
459         address token,
460         uint256 liquidity,
461         uint256 amountTokenMin,
462         uint256 amountETHMin,
463         address to,
464         uint256 deadline
465     ) external returns (uint256 amountToken, uint256 amountETH);
466 
467     function removeLiquidityWithPermit(
468         address tokenA,
469         address tokenB,
470         uint256 liquidity,
471         uint256 amountAMin,
472         uint256 amountBMin,
473         address to,
474         uint256 deadline,
475         bool approveMax,
476         uint8 v,
477         bytes32 r,
478         bytes32 s
479     ) external returns (uint256 amountA, uint256 amountB);
480 
481     function removeLiquidityETHWithPermit(
482         address token,
483         uint256 liquidity,
484         uint256 amountTokenMin,
485         uint256 amountETHMin,
486         address to,
487         uint256 deadline,
488         bool approveMax,
489         uint8 v,
490         bytes32 r,
491         bytes32 s
492     ) external returns (uint256 amountToken, uint256 amountETH);
493 
494     function swapExactTokensForTokens(
495         uint256 amountIn,
496         uint256 amountOutMin,
497         address[] calldata path,
498         address to,
499         uint256 deadline
500     ) external returns (uint256[] memory amounts);
501 
502     function swapTokensForExactTokens(
503         uint256 amountOut,
504         uint256 amountInMax,
505         address[] calldata path,
506         address to,
507         uint256 deadline
508     ) external returns (uint256[] memory amounts);
509 
510     function swapExactETHForTokens(
511         uint256 amountOutMin,
512         address[] calldata path,
513         address to,
514         uint256 deadline
515     ) external payable returns (uint256[] memory amounts);
516 
517     function swapTokensForExactETH(
518         uint256 amountOut,
519         uint256 amountInMax,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external returns (uint256[] memory amounts);
524 
525     function swapExactTokensForETH(
526         uint256 amountIn,
527         uint256 amountOutMin,
528         address[] calldata path,
529         address to,
530         uint256 deadline
531     ) external returns (uint256[] memory amounts);
532 
533     function swapETHForExactTokens(
534         uint256 amountOut,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external payable returns (uint256[] memory amounts);
539 
540     function quote(
541         uint256 amountA,
542         uint256 reserveA,
543         uint256 reserveB
544     ) external pure returns (uint256 amountB);
545 
546     function getAmountOut(
547         uint256 amountIn,
548         uint256 reserveIn,
549         uint256 reserveOut
550     ) external pure returns (uint256 amountOut);
551 
552     function getAmountIn(
553         uint256 amountOut,
554         uint256 reserveIn,
555         uint256 reserveOut
556     ) external pure returns (uint256 amountIn);
557 
558     function getAmountsOut(uint256 amountIn, address[] calldata path)
559         external
560         view
561         returns (uint256[] memory amounts);
562 
563     function getAmountsIn(uint256 amountOut, address[] calldata path)
564         external
565         view
566         returns (uint256[] memory amounts);
567 }
568 
569 interface IUniswapV2Router02 is IUniswapV2Router01 {
570     function removeLiquidityETHSupportingFeeOnTransferTokens(
571         address token,
572         uint256 liquidity,
573         uint256 amountTokenMin,
574         uint256 amountETHMin,
575         address to,
576         uint256 deadline
577     ) external returns (uint256 amountETH);
578 
579     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
580         address token,
581         uint256 liquidity,
582         uint256 amountTokenMin,
583         uint256 amountETHMin,
584         address to,
585         uint256 deadline,
586         bool approveMax,
587         uint8 v,
588         bytes32 r,
589         bytes32 s
590     ) external returns (uint256 amountETH);
591 
592     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
593         uint256 amountIn,
594         uint256 amountOutMin,
595         address[] calldata path,
596         address to,
597         uint256 deadline
598     ) external;
599 
600     function swapExactETHForTokensSupportingFeeOnTransferTokens(
601         uint256 amountOutMin,
602         address[] calldata path,
603         address to,
604         uint256 deadline
605     ) external payable;
606 
607     function swapExactTokensForETHSupportingFeeOnTransferTokens(
608         uint256 amountIn,
609         uint256 amountOutMin,
610         address[] calldata path,
611         address to,
612         uint256 deadline
613     ) external;
614 }
615 
616 contract SUPNETWORK is Context, IERC20, Ownable {
617     using SafeMath for uint256;
618     using Address for address;
619 
620     address payable public marketingAddress;
621     address payable public rewardAddress;
622     address payable public liquidityAddress;
623 
624     mapping(address => uint256) private _rOwned;
625     mapping(address => uint256) private _tOwned;
626     mapping(address => mapping(address => uint256)) private _allowances;
627 
628     mapping(address => bool) private _isExcludedFromFee;
629 
630     mapping(address => bool) private _isExcluded;
631     address[] private _excluded;
632 
633     uint256 private constant MAX = ~uint256(0);
634     uint256 private constant _tTotal = 1 * 1e9 * 1e18;
635     uint256 private _rTotal = (MAX - (MAX % _tTotal));
636     uint256 private _tFeeTotal;
637 
638     string private constant _name = "SUP Network";
639     string private constant _symbol = "SUP";
640     uint8 private constant _decimals = 18;
641 
642     uint256 private constant BUY = 1;
643     uint256 private constant SELL = 2;
644     uint256 private constant TRANSFER = 3;
645     uint256 private buyOrSellSwitch;
646 
647     uint256 private _taxFee;
648     uint256 private _previousTaxFee = _taxFee;
649 
650     uint256 private _liquidityFee;
651     uint256 private _previousLiquidityFee = _liquidityFee;
652 
653     uint256 public _buyTaxFee;
654     uint256 public _buyLiquidityFee = 1;
655     uint256 public _buyRewardFee;
656     uint256 public _buyMarketingFee = 4;
657 
658     uint256 public _sellTaxFee;
659     uint256 public _sellLiquidityFee = 1;
660     uint256 public _sellRewardFee;
661     uint256 public _sellMarketingFee = 4;
662 
663     uint256 public tradingActiveBlock;
664     uint256 public deadBlocks;
665 
666     bool public limitsInEffect = true;
667     bool public tradingActive = false;
668     bool public swapEnabled = false;
669 
670     mapping (address => bool) public _isExcludedMaxTransactionAmount;
671 
672     mapping(address => uint256) private _holderLastTransferTimestamp;
673     bool public transferDelayEnabled = true;
674 
675     uint256 private _liquidityTokensToSwap;
676     uint256 private _rewardTokens;
677     uint256 private _marketingTokensToSwap;
678 
679     bool private gasLimitActive = true;
680     uint256 private gasPriceLimit = 600 * 1 gwei;
681 
682     mapping (address => bool) public automatedMarketMakerPairs;
683     mapping (address => bool) private _isSniper;
684 
685     uint256 public minimumTokensBeforeSwap;
686     uint256 public maxTransactionAmount;
687     uint256 public maxWallet;
688 
689     IUniswapV2Router02 public uniswapV2Router;
690     address public uniswapV2Pair;
691 
692     bool inSwapAndLiquify;
693     bool public swapAndLiquifyEnabled = false;
694 
695     event RewardLiquidityProviders(uint256 tokenAmount);
696     event SwapAndLiquifyEnabledUpdated(bool enabled);
697     event SwapAndLiquify(
698         uint256 tokensSwapped,
699         uint256 ethReceived,
700         uint256 tokensIntoLiqudity
701     );
702 
703     event SwapETHForTokens(uint256 amountIn, address[] path);
704 
705     event SwapTokensForETH(uint256 amountIn, address[] path);
706 
707     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
708 
709     event ManualBurnLP();
710 
711     modifier lockTheSwap() {
712         inSwapAndLiquify = true;
713         _;
714         inSwapAndLiquify = false;
715     }
716 
717     constructor() {
718         deadBlocks = 2;
719 
720         maxTransactionAmount = _tTotal * 50 / 10000; // 0.5% max txn
721         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
722         maxWallet = _tTotal * 100 / 10000; // 1%
723 
724         _rOwned[msg.sender] = _rTotal;
725 
726         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
727             // ROPSTEN or HARDHAT
728             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
729         );
730 
731         liquidityAddress = payable(msg.sender);
732         marketingAddress = payable(msg.sender);
733         rewardAddress = payable(msg.sender);
734 
735         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
736             .createPair(address(this), _uniswapV2Router.WETH());
737 
738         uniswapV2Router = _uniswapV2Router;
739         uniswapV2Pair = _uniswapV2Pair;
740 
741         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
742 
743         _isExcludedFromFee[msg.sender] = true;
744         _isExcludedFromFee[address(this)] = true;
745 
746         excludeFromMaxTransaction(msg.sender, true);
747         excludeFromMaxTransaction(address(this), true);
748         excludeFromMaxTransaction(address(_uniswapV2Router), true);
749         excludeFromMaxTransaction(address(0xdead), true);
750 
751         emit Transfer(address(0), msg.sender, _tTotal);
752     }
753 
754     function name() external pure returns (string memory) {
755         return _name;
756     }
757 
758     function symbol() external pure returns (string memory) {
759         return _symbol;
760     }
761 
762     function decimals() external pure returns (uint8) {
763         return _decimals;
764     }
765 
766     function totalSupply() external pure override returns (uint256) {
767         return _tTotal;
768     }
769 
770     function balanceOf(address account) public view override returns (uint256) {
771         if (_isExcluded[account]) return _tOwned[account];
772         return tokenFromReflection(_rOwned[account]);
773     }
774 
775     function transfer(address recipient, uint256 amount)
776         external
777         override
778         returns (bool)
779     {
780         _transfer(_msgSender(), recipient, amount);
781         return true;
782     }
783 
784     function allowance(address owner, address spender)
785         external
786         view
787         override
788         returns (uint256)
789     {
790         return _allowances[owner][spender];
791     }
792 
793     function approve(address spender, uint256 amount)
794         public
795         override
796         returns (bool)
797     {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     function transferFrom(
803         address sender,
804         address recipient,
805         uint256 amount
806     ) external override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(
809             sender,
810             _msgSender(),
811             _allowances[sender][_msgSender()].sub(
812                 amount,
813                 "ERC20: transfer amount exceeds allowance"
814             )
815         );
816         return true;
817     }
818 
819     function increaseAllowance(address spender, uint256 addedValue)
820         external
821         virtual
822         returns (bool)
823     {
824         _approve(
825             _msgSender(),
826             spender,
827             _allowances[_msgSender()][spender].add(addedValue)
828         );
829         return true;
830     }
831 
832     function decreaseAllowance(address spender, uint256 subtractedValue)
833         external
834         virtual
835         returns (bool)
836     {
837         _approve(
838             _msgSender(),
839             spender,
840             _allowances[_msgSender()][spender].sub(
841                 subtractedValue,
842                 "ERC20: decreased allowance below zero"
843             )
844         );
845         return true;
846     }
847 
848     function isExcludedFromReward(address account)
849         external
850         view
851         returns (bool)
852     {
853         return _isExcluded[account];
854     }
855 
856     function totalFees() external view returns (uint256) {
857         return _tFeeTotal;
858     }
859 
860     // once enabled, can never be turned off
861     function enableTrading(uint256 _deadBlocks) external onlyOwner {
862         tradingActive = true;
863         swapAndLiquifyEnabled = true;
864         tradingActiveBlock = block.number;
865         deadBlocks = _deadBlocks;
866     }
867 
868     function isSniper(address account) public view returns (bool) {
869         return _isSniper[account];
870     }
871     
872     function manageSnipers(address[] calldata addresses, bool status) public onlyOwner {
873         for (uint256 i; i < addresses.length; ++i) {
874             if (status == true) {
875                 require(addresses[i] != address(this), "Can't blacklist token contract");
876                 require(addresses[i] != uniswapV2Pair, "Can't blacklist pair contract");
877             }
878             _isSniper[addresses[i]] = status;
879         }
880     }
881 
882     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
883         return minimumTokensBeforeSwap;
884     }
885 
886     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
887         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
888 
889         _setAutomatedMarketMakerPair(pair, value);
890     }
891 
892     function _setAutomatedMarketMakerPair(address pair, bool value) private {
893         automatedMarketMakerPairs[pair] = value;
894 
895         excludeFromMaxTransaction(pair, value);
896         if(value){excludeFromReward(pair);}
897         if(!value){includeInReward(pair);}
898     }
899 
900     function setProtectionSettings(bool antiGas) external onlyOwner() {
901         gasLimitActive = antiGas;
902     }
903 
904     function setGasPriceLimit(uint256 gas) external onlyOwner {
905         require(gas >= 300);
906         gasPriceLimit = gas * 1 gwei;
907     }
908 
909     // disable Transfer delay
910     function disableTransferDelay() external onlyOwner returns (bool){
911         transferDelayEnabled = false;
912         return true;
913     }
914 
915     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
916         external
917         view
918         returns (uint256)
919     {
920         require(tAmount <= _tTotal, "Amount must be less than supply");
921         if (!deductTransferFee) {
922             (uint256 rAmount, , , , , ) = _getValues(tAmount);
923             return rAmount;
924         } else {
925             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
926             return rTransferAmount;
927         }
928     }
929 
930     // remove limits after token is stable - 30-60 minutes
931     function removeLimits() external onlyOwner returns (bool){
932         limitsInEffect = false;
933         gasLimitActive = false;
934         transferDelayEnabled = false;
935         return true;
936     }
937 
938     function tokenFromReflection(uint256 rAmount)
939         public
940         view
941         returns (uint256)
942     {
943         require(
944             rAmount <= _rTotal,
945             "Amount must be less than total reflections"
946         );
947         uint256 currentRate = _getRate();
948         return rAmount.div(currentRate);
949     }
950 
951     function excludeFromReward(address account) public onlyOwner {
952         require(!_isExcluded[account], "Account is already excluded");
953         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
954         if (_rOwned[account] > 0) {
955             _tOwned[account] = tokenFromReflection(_rOwned[account]);
956         }
957         _isExcluded[account] = true;
958         _excluded.push(account);
959     }
960 
961     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
962         _isExcludedMaxTransactionAmount[updAds] = isEx;
963         emit ExcludedMaxTransactionAmount(updAds, isEx);
964     }
965 
966     function includeInReward(address account) public onlyOwner {
967         require(_isExcluded[account], "Account is not excluded");
968         for (uint256 i = 0; i < _excluded.length; i++) {
969             if (_excluded[i] == account) {
970                 _excluded[i] = _excluded[_excluded.length - 1];
971                 _tOwned[account] = 0;
972                 _isExcluded[account] = false;
973                 _excluded.pop();
974                 break;
975             }
976         }
977     }
978 
979     function _approve(
980         address owner,
981         address spender,
982         uint256 amount
983     ) private {
984         require(owner != address(0), "ERC20: approve from the zero address");
985         require(spender != address(0), "ERC20: approve to the zero address");
986 
987         _allowances[owner][spender] = amount;
988         emit Approval(owner, spender, amount);
989     }
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) private {
996         require(to != address(0) && from != address(0), "ERC20: transfer from the zero address");
997         require(amount > 0, "Transfer amount must be greater than zero");
998 
999         if(limitsInEffect){
1000             if (
1001                 from != owner() &&
1002                 to != owner() &&
1003                 to != address(0) &&
1004                 to != address(0xdead) &&
1005                 !inSwapAndLiquify
1006             ){
1007 
1008                 // When trading is not active
1009                 require(tradingActive, "Trading is not active yet");
1010                 if (tradingActiveBlock > 0 && tradingActiveBlock + deadBlocks > block.number) {
1011                     _isSniper[to] = true;
1012                 }
1013 
1014                 // only use to prevent sniper buys in the first blocks.
1015                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1016                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1017                 }
1018 
1019                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1020                 if (transferDelayEnabled){
1021                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1022                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1023                         _holderLastTransferTimestamp[tx.origin] = block.number;
1024                     }
1025                 }
1026 
1027                 //when buy
1028                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1029                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1030                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1031                 }
1032                 //when sell
1033                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1034                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1035                 }
1036                 else if (!_isExcludedMaxTransactionAmount[to]){
1037                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1038                 }
1039             }
1040         }
1041 
1042         uint256 contractTokenBalance = balanceOf(address(this));
1043         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1044 
1045         // Sell tokens for ETH
1046         if (
1047             !inSwapAndLiquify &&
1048             swapAndLiquifyEnabled &&
1049             balanceOf(uniswapV2Pair) > 0 &&
1050             overMinimumTokenBalance &&
1051             automatedMarketMakerPairs[to]
1052         ) {
1053             swapBack();
1054         }
1055 
1056         removeAllFee();
1057 
1058         buyOrSellSwitch = TRANSFER;
1059 
1060         // If any account belongs to _isExcludedFromFee account then remove the fee
1061         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1062             // Buy
1063             if (automatedMarketMakerPairs[from]) {
1064                 _taxFee = _buyTaxFee;
1065                 _liquidityFee = _buyLiquidityFee + _buyRewardFee + _buyMarketingFee;
1066                 if(_liquidityFee > 0){
1067                     buyOrSellSwitch = BUY;
1068                 }
1069             }
1070             // Sell
1071             else if (automatedMarketMakerPairs[to]) {
1072                 _taxFee = _sellTaxFee;
1073                 _liquidityFee = _sellLiquidityFee + _sellRewardFee + _sellMarketingFee;
1074                 if(_liquidityFee > 0){
1075                     buyOrSellSwitch = SELL;
1076                 }
1077             }
1078 
1079             // If sniper buy or sell, increase liquidity fee
1080             if ((_isSniper[to] || _isSniper[from]) && _liquidityFee > 0) {
1081                 _liquidityFee = 99;
1082             }
1083         }
1084 
1085         _tokenTransfer(from, to, amount);
1086 
1087         restoreAllFee();
1088 
1089     }
1090     
1091     // change the minimum amount of tokens to sell from fees
1092     function updateSwapTokensAtPercent(uint256 percent) external onlyOwner returns (bool){
1093   	    require(percent >= 1, "Swap amount cannot be lower than 0.001% total supply.");
1094   	    require(percent <= 50, "Swap amount cannot be higher than 0.5% total supply.");
1095   	    minimumTokensBeforeSwap = _tTotal * percent / 10000;
1096   	    return true;
1097   	}
1098 
1099     function updateMaxTxnPercent(uint256 percent) external onlyOwner {
1100         require(percent >= 10, "Cannot set maxTransactionAmount lower than 0.1%");
1101         maxTransactionAmount = _tTotal * percent / 10000;
1102     }
1103 
1104     function swapBack() private lockTheSwap {
1105         uint256 contractBalance = balanceOf(address(this));
1106         bool success;
1107         uint256 totalTokensToSwap = _liquidityTokensToSwap + _rewardTokens + _marketingTokensToSwap;
1108         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1109 
1110         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1111         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity).sub(_rewardTokens);
1112 
1113         uint256 initialETHBalance = address(this).balance;
1114 
1115         swapTokensForETH(amountToSwapForETH);
1116 
1117         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1118 
1119         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1120 
1121         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1122 
1123         // Transfer rewards token to reward wallet
1124         uint256 currentRate = _getRate();
1125         uint256 rReward = _rewardTokens.mul(currentRate);
1126         _rOwned[address(rewardAddress)] = _rOwned[address(rewardAddress)].add(rReward);
1127         _tOwned[address(rewardAddress)] = _tOwned[address(rewardAddress)].add(_rewardTokens);
1128 
1129         _liquidityTokensToSwap = 0;
1130         _rewardTokens = 0;
1131         _marketingTokensToSwap = 0;
1132 
1133         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
1134             addLiquidity(tokensForLiquidity, ethForLiquidity);
1135             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1136         }
1137 
1138         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1139 
1140     }
1141 
1142     function swapTokensForETH(uint256 tokenAmount) private {
1143         address[] memory path = new address[](2);
1144         path[0] = address(this);
1145         path[1] = uniswapV2Router.WETH();
1146         _approve(address(this), address(uniswapV2Router), tokenAmount);
1147         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1148             tokenAmount,
1149             0,
1150             path,
1151             address(this),
1152             block.timestamp
1153         );
1154     }
1155 
1156     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1157         _approve(address(this), address(uniswapV2Router), tokenAmount);
1158         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1159             address(this),
1160             tokenAmount,
1161             0,
1162             0,
1163             liquidityAddress,
1164             block.timestamp
1165         );
1166     }
1167 
1168     function _tokenTransfer(
1169         address sender,
1170         address recipient,
1171         uint256 amount
1172     ) private {
1173 
1174         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1175             _transferFromExcluded(sender, recipient, amount);
1176         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1177             _transferToExcluded(sender, recipient, amount);
1178         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferBothExcluded(sender, recipient, amount);
1180         } else {
1181             _transferStandard(sender, recipient, amount);
1182         }
1183     }
1184 
1185     function _transferStandard(
1186         address sender,
1187         address recipient,
1188         uint256 tAmount
1189     ) private {
1190         (
1191             uint256 rAmount,
1192             uint256 rTransferAmount,
1193             uint256 rFee,
1194             uint256 tTransferAmount,
1195             uint256 tFee,
1196             uint256 tLiquidity
1197         ) = _getValues(tAmount);
1198         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1199         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1200         _takeLiquidity(tLiquidity);
1201         _reflectFee(rFee, tFee);
1202         emit Transfer(sender, recipient, tTransferAmount);
1203     }
1204 
1205     function _transferToExcluded(
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
1219         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1220         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1221         _takeLiquidity(tLiquidity);
1222         _reflectFee(rFee, tFee);
1223         emit Transfer(sender, recipient, tTransferAmount);
1224     }
1225 
1226     function _transferFromExcluded(
1227         address sender,
1228         address recipient,
1229         uint256 tAmount
1230     ) private {
1231         (
1232             uint256 rAmount,
1233             uint256 rTransferAmount,
1234             uint256 rFee,
1235             uint256 tTransferAmount,
1236             uint256 tFee,
1237             uint256 tLiquidity
1238         ) = _getValues(tAmount);
1239         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1240         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1242         _takeLiquidity(tLiquidity);
1243         _reflectFee(rFee, tFee);
1244         emit Transfer(sender, recipient, tTransferAmount);
1245     }
1246 
1247     function _transferBothExcluded(
1248         address sender,
1249         address recipient,
1250         uint256 tAmount
1251     ) private {
1252         (
1253             uint256 rAmount,
1254             uint256 rTransferAmount,
1255             uint256 rFee,
1256             uint256 tTransferAmount,
1257             uint256 tFee,
1258             uint256 tLiquidity
1259         ) = _getValues(tAmount);
1260         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1261         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1262         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1263         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1264         _takeLiquidity(tLiquidity);
1265         _reflectFee(rFee, tFee);
1266         emit Transfer(sender, recipient, tTransferAmount);
1267     }
1268 
1269     function _reflectFee(uint256 rFee, uint256 tFee) private {
1270         _rTotal = _rTotal.sub(rFee);
1271         _tFeeTotal = _tFeeTotal.add(tFee);
1272     }
1273 
1274     function _getValues(uint256 tAmount)
1275         private
1276         view
1277         returns (
1278             uint256,
1279             uint256,
1280             uint256,
1281             uint256,
1282             uint256,
1283             uint256
1284         )
1285     {
1286         (
1287             uint256 tTransferAmount,
1288             uint256 tFee,
1289             uint256 tLiquidity
1290         ) = _getTValues(tAmount);
1291         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1292             tAmount,
1293             tFee,
1294             tLiquidity,
1295             _getRate()
1296         );
1297         return (
1298             rAmount,
1299             rTransferAmount,
1300             rFee,
1301             tTransferAmount,
1302             tFee,
1303             tLiquidity
1304         );
1305     }
1306 
1307     function _getTValues(uint256 tAmount)
1308         private
1309         view
1310         returns (
1311             uint256,
1312             uint256,
1313             uint256
1314         )
1315     {
1316         uint256 tFee = calculateTaxFee(tAmount);
1317         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1318         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1319         return (tTransferAmount, tFee, tLiquidity);
1320     }
1321 
1322     function _getRValues(
1323         uint256 tAmount,
1324         uint256 tFee,
1325         uint256 tLiquidity,
1326         uint256 currentRate
1327     )
1328         private
1329         pure
1330         returns (
1331             uint256,
1332             uint256,
1333             uint256
1334         )
1335     {
1336         uint256 rAmount = tAmount.mul(currentRate);
1337         uint256 rFee = tFee.mul(currentRate);
1338         uint256 rLiquidity = tLiquidity.mul(currentRate);
1339         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1340         return (rAmount, rTransferAmount, rFee);
1341     }
1342 
1343     function _getRate() private view returns (uint256) {
1344         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1345         return rSupply.div(tSupply);
1346     }
1347 
1348     function _getCurrentSupply() private view returns (uint256, uint256) {
1349         uint256 rSupply = _rTotal;
1350         uint256 tSupply = _tTotal;
1351         for (uint256 i = 0; i < _excluded.length; i++) {
1352             if (
1353                 _rOwned[_excluded[i]] > rSupply ||
1354                 _tOwned[_excluded[i]] > tSupply
1355             ) return (_rTotal, _tTotal);
1356             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1357             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1358         }
1359         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1360         return (rSupply, tSupply);
1361     }
1362 
1363     function _takeLiquidity(uint256 tLiquidity) private {
1364         if(buyOrSellSwitch == BUY){
1365             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1366             _rewardTokens += tLiquidity * _buyRewardFee / _liquidityFee;
1367             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1368         } else if(buyOrSellSwitch == SELL){
1369             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1370             _rewardTokens += tLiquidity * _sellRewardFee / _liquidityFee;
1371             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1372         }
1373         
1374         uint256 currentRate = _getRate();
1375         uint256 rLiquidity = tLiquidity.mul(currentRate);
1376         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1377         if (_isExcluded[address(this)])
1378             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1379     }
1380 
1381     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1382         return _amount.mul(_taxFee).div(10**2);
1383     }
1384 
1385     function calculateLiquidityFee(uint256 _amount)
1386         private
1387         view
1388         returns (uint256)
1389     {
1390         return _amount.mul(_liquidityFee).div(10**2);
1391     }
1392 
1393     function removeAllFee() private {
1394         if (_taxFee == 0 && _liquidityFee == 0) return;
1395 
1396         _previousTaxFee = _taxFee;
1397         _previousLiquidityFee = _liquidityFee;
1398 
1399         _taxFee = 0;
1400         _liquidityFee = 0;
1401     }
1402 
1403     function restoreAllFee() private {
1404         _taxFee = _previousTaxFee;
1405         _liquidityFee = _previousLiquidityFee;
1406     }
1407 
1408     function isExcludedFromFee(address account) external view returns (bool) {
1409         return _isExcludedFromFee[account];
1410     }
1411 
1412     function excludeFromFee(address account) external onlyOwner {
1413         _isExcludedFromFee[account] = true;
1414     }
1415 
1416     function includeInFee(address account) external onlyOwner {
1417         _isExcludedFromFee[account] = false;
1418     }
1419 
1420     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyRewardFee, uint256 buyMarketingFee)
1421         external
1422         onlyOwner
1423     {
1424         _buyTaxFee = buyTaxFee;
1425         _buyLiquidityFee = buyLiquidityFee;
1426         _buyRewardFee = buyRewardFee;
1427         _buyMarketingFee = buyMarketingFee;
1428         require(_buyTaxFee + _buyLiquidityFee + _buyRewardFee + _buyMarketingFee <= 10, "Must keep taxes below 10%");
1429     }
1430 
1431     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellRewardFee, uint256 sellMarketingFee)
1432         external
1433         onlyOwner
1434     {
1435         _sellTaxFee = sellTaxFee;
1436         _sellLiquidityFee = sellLiquidityFee;
1437         _sellRewardFee = sellRewardFee;
1438         _sellMarketingFee = sellMarketingFee;
1439         require(_sellTaxFee + _sellLiquidityFee + _sellRewardFee + _sellMarketingFee <= 25, "Must keep taxes below 25%");
1440     }
1441 
1442     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1443         marketingAddress = payable(_marketingAddress);
1444         _isExcludedFromFee[marketingAddress] = true;
1445     }
1446 
1447     function setRewardAddress(address _rewardAddress) external onlyOwner {
1448         rewardAddress = payable(_rewardAddress);
1449         _isExcludedFromFee[rewardAddress] = true;
1450     }
1451 
1452     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1453         liquidityAddress = payable(_liquidityAddress);
1454         _isExcludedFromFee[liquidityAddress] = true;
1455     }
1456 
1457     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1458         swapAndLiquifyEnabled = _enabled;
1459         emit SwapAndLiquifyEnabledUpdated(_enabled);
1460     }
1461 
1462     // Buyback tokens and send to  dead address
1463     function buyBackTokens(uint256 ethAmountInWei) external payable onlyOwner {
1464         // generate the uniswap pair path of weth -> eth
1465         address[] memory path = new address[](2);
1466         path[0] = uniswapV2Router.WETH();
1467         path[1] = address(this);
1468 
1469         // make the swap
1470         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1471             0, // accept any amount of Token
1472             path,
1473             address(0xdead),
1474             block.timestamp
1475         );
1476     }
1477 
1478     // To receive ETH from uniswapV2Router when swapping
1479     receive() external payable {}
1480 
1481     function withdrawStuckTokens(address _token, address _to)
1482         external
1483         onlyOwner
1484         returns (bool _sent)
1485     {
1486         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1487         _sent = IERC20(_token).transfer(_to, _contractBalance);
1488     }
1489 
1490     function manualSend(address _recipient) external onlyOwner {
1491         uint256 contractETHBalance = address(this).balance;
1492         (bool success, ) = _recipient.call{ value: contractETHBalance }("");
1493         require(success, "Address: unable to send value, recipient may have reverted");
1494     }
1495 }