1 pragma solidity ^0.8.9;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
231     function renounceOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     function transferOwnership(address newOwner) public virtual onlyOwner {
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
598 contract TOPCAT_INU is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress;
603         
604     address payable public devAddress;
605         
606     address payable public liquidityAddress;
607     
608     address private _owner = 0xb678eE07f9b4AF0fd01F7d64E046f86AE78F47aE;
609         
610     mapping(address => uint256) private _rOwned;
611     mapping(address => uint256) private _tOwned;
612     mapping(address => mapping(address => uint256)) private _allowances;
613     
614     // Anti-bot and anti-whale mappings and variables
615     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
616     bool public transferDelayEnabled = true;
617     bool public limitsInEffect = true;
618 
619     mapping(address => bool) private _isExcludedFromFee;
620 
621     mapping(address => bool) private _isExcluded;
622     address[] private _excluded;
623     
624     uint256 private constant MAX = ~uint256(0);
625     uint256 private constant _tTotal = 1 * 1e15 * 1e9;
626     uint256 private _rTotal = (MAX - (MAX % _tTotal));
627     uint256 private _tFeeTotal;
628 
629     string private constant _name = "TOPCAT INU";
630     string private constant _symbol = "TCAT";
631     uint8 private constant _decimals = 9;
632 
633     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
634     uint256 private _taxFee;
635     uint256 private _previousTaxFee = _taxFee;
636 
637     uint256 private _marketingFee;
638     
639     uint256 private _liquidityFee;
640     uint256 private _previousLiquidityFee = _liquidityFee;
641     
642     uint256 private constant BUY = 1;
643     uint256 private constant SELL = 2;
644     uint256 private constant TRANSFER = 3;
645     uint256 private buyOrSellSwitch;
646 
647     uint256 public _buyTaxFee = 2;
648     uint256 public _buyLiquidityFee = 1;
649     uint256 public _buyMarketingFee = 7;
650     
651     uint256 public _sellTaxFee = 2;
652     uint256 public _sellLiquidityFee = 1;
653     uint256 public _sellMarketingFee = 7;
654     
655     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
656     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
657     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
658     
659     uint256 public _liquidityTokensToSwap;
660     uint256 public _marketingTokensToSwap;
661     
662     uint256 public maxTransactionAmount;
663     uint256 public maxWalletAmount;
664     mapping (address => bool) public _isExcludedMaxTransactionAmount;
665     
666     bool private gasLimitActive = true;
667     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
668     
669     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
670     // could be subject to a maximum transfer amount
671     mapping (address => bool) public automatedMarketMakerPairs;
672 
673     uint256 private minimumTokensBeforeSwap;
674 
675     IUniswapV2Router02 public uniswapV2Router;
676     address public uniswapV2Pair;
677 
678     bool inSwapAndLiquify;
679     bool public swapAndLiquifyEnabled = false;
680     bool public tradingActive = false;
681 
682     event SwapAndLiquifyEnabledUpdated(bool enabled);
683     event SwapAndLiquify(
684         uint256 tokensSwapped,
685         uint256 ethReceived,
686         uint256 tokensIntoLiquidity
687     );
688 
689     event SwapETHForTokens(uint256 amountIn, address[] path);
690 
691     event SwapTokensForETH(uint256 amountIn, address[] path);
692     
693     event SetAutomatedMarketMakerPair(address pair, bool value);
694     
695     event ExcludeFromReward(address excludedAddress);
696     
697     event IncludeInReward(address includedAddress);
698     
699     event ExcludeFromFee(address excludedAddress);
700     
701     event IncludeInFee(address includedAddress);
702     
703     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
704     
705     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
706     
707     event TransferForeignToken(address token, uint256 amount);
708     
709     event UpdatedMarketingAddress(address marketing);
710     
711     event UpdatedLiquidityAddress(address liquidity);
712     
713     event OwnerForcedSwapBack(uint256 timestamp);
714     
715     event BoughtEarly(address indexed sniper);
716     
717     event RemovedSniper(address indexed notsnipersupposedly);
718 
719     modifier lockTheSwap() {
720         inSwapAndLiquify = true;
721         _;
722         inSwapAndLiquify = false;
723     }
724 
725     constructor() payable {
726         _rOwned[_owner] = _rTotal / 1000 * 400;
727         _rOwned[address(this)] = _rTotal / 1000 * 600;
728         
729         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
730         maxWalletAmount = _tTotal * 15 / 1000; // 1.5% maxWalletAmount
731         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
732         
733         marketingAddress = payable(0xecfE92B57b4c3150F1cC31A575a854D507D1C839); // Marketing Address
734         
735         devAddress = payable(0xC772Ad89bAFa73351c90BA242356de91E1cE97d7); // Dev Address
736         
737         liquidityAddress = payable(owner()); 
738         
739         _isExcludedFromFee[owner()] = true;
740         _isExcludedFromFee[address(this)] = true;
741         _isExcludedFromFee[marketingAddress] = true;
742         _isExcludedFromFee[liquidityAddress] = true;
743         
744         excludeFromMaxTransaction(owner(), true);
745         excludeFromMaxTransaction(address(this), true);
746         excludeFromMaxTransaction(address(0xdead), true);
747         
748         emit Transfer(address(0), _owner, _tTotal * 400 / 1000);
749         emit Transfer(address(0), address(this), _tTotal * 600 / 1000);
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
858     // remove limits after token is stable - 30-60 minutes
859     function removeLimits() external onlyOwner returns (bool){
860         limitsInEffect = false;
861         gasLimitActive = false;
862         transferDelayEnabled = false;
863         return true;
864     }
865     
866     // disable Transfer delay
867     function disableTransferDelay() external onlyOwner returns (bool){
868         transferDelayEnabled = false;
869         return true;
870     }
871     
872     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
873         _isExcludedMaxTransactionAmount[updAds] = isEx;
874     }
875     
876     // once enabled, can never be turned off
877     function enableTrading() internal onlyOwner {
878         tradingActive = true;
879         swapAndLiquifyEnabled = true;
880         tradingActiveBlock = block.number;
881         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
882     }
883     
884     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
885     function launch() external onlyOwner returns (bool){
886         require(!tradingActive, "Trading is already active, cannot relaunch.");
887         
888         enableTrading();
889         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
890         excludeFromMaxTransaction(address(_uniswapV2Router), true);
891         uniswapV2Router = _uniswapV2Router;
892         _approve(address(this), address(uniswapV2Router), _tTotal);
893         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
894         excludeFromMaxTransaction(address(uniswapV2Pair), true);
895         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
896         require(address(this).balance > 0, "Must have ETH on contract to launch");
897         addLiquidity(balanceOf(address(this)), address(this).balance);
898         transferOwnership(_owner);
899         return true;
900     }
901     
902     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
903         return minimumTokensBeforeSwap;
904     }
905     
906     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
907         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
908 
909         _setAutomatedMarketMakerPair(pair, value);
910     }
911 
912     function _setAutomatedMarketMakerPair(address pair, bool value) private {
913         automatedMarketMakerPairs[pair] = value;
914         _isExcludedMaxTransactionAmount[pair] = value;
915         if(value){excludeFromReward(pair);}
916         if(!value){includeInReward(pair);}
917     }
918     
919     function setGasPriceLimit(uint256 gas) external onlyOwner {
920         require(gas >= 200);
921         gasPriceLimit = gas * 1 gwei;
922     }
923 
924     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
925         external
926         view
927         returns (uint256)
928     {
929         require(tAmount <= _tTotal, "Amount must be less than supply");
930         if (!deductTransferFee) {
931             (uint256 rAmount, , , , , ) = _getValues(tAmount);
932             return rAmount;
933         } else {
934             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
935             return rTransferAmount;
936         }
937     }
938 
939     function tokenFromReflection(uint256 rAmount)
940         public
941         view
942         returns (uint256)
943     {
944         require(
945             rAmount <= _rTotal,
946             "Amount must be less than total reflections"
947         );
948         uint256 currentRate = _getRate();
949         return rAmount.div(currentRate);
950     }
951 
952     function excludeFromReward(address account) public onlyOwner {
953         require(!_isExcluded[account], "Account is already excluded");
954         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
955         if (_rOwned[account] > 0) {
956             _tOwned[account] = tokenFromReflection(_rOwned[account]);
957         }
958         _isExcluded[account] = true;
959         _excluded.push(account);
960     }
961 
962     function includeInReward(address account) public onlyOwner {
963         require(_isExcluded[account], "Account is not excluded");
964         for (uint256 i = 0; i < _excluded.length; i++) {
965             if (_excluded[i] == account) {
966                 _excluded[i] = _excluded[_excluded.length - 1];
967                 _tOwned[account] = 0;
968                 _isExcluded[account] = false;
969                 _excluded.pop();
970                 break;
971             }
972         }
973     }
974  
975     function _approve(
976         address owner,
977         address spender,
978         uint256 amount
979     ) private {
980         require(owner != address(0), "ERC20: approve from the zero address");
981         require(spender != address(0), "ERC20: approve to the zero address");
982 
983         _allowances[owner][spender] = amount;
984         emit Approval(owner, spender, amount);
985     }
986 
987     function _transfer(
988         address from,
989         address to,
990         uint256 amount
991     ) private {
992         require(from != address(0), "ERC20: transfer from the zero address");
993         require(to != address(0), "ERC20: transfer to the zero address");
994         require(amount > 0, "Transfer amount must be greater than zero");
995         
996         if(!tradingActive){
997             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
998         }
999         
1000         
1001         
1002         if(limitsInEffect){
1003             if (
1004                 from != owner() &&
1005                 to != owner() &&
1006                 to != address(0) &&
1007                 to != address(0xdead) &&
1008                 !inSwapAndLiquify
1009             ){
1010                 
1011                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1012                     boughtEarly[to] = true;
1013                     emit BoughtEarly(to);
1014                 }
1015                 
1016                 // only use to prevent sniper buys in the first blocks.
1017                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1018                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1019                 }
1020                 
1021                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1022                 if (transferDelayEnabled){
1023                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1024                         require(_holderLastTransferTimestamp[to] < block.number && _holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1025                         _holderLastTransferTimestamp[to] = block.number;
1026                         _holderLastTransferTimestamp[tx.origin] = block.number;
1027                     }
1028                 }
1029                 
1030                 //when buy
1031                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1032                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1033                 } 
1034                 //when sell
1035                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1036                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1037                 }
1038                 
1039                 if (!_isExcludedMaxTransactionAmount[to]) {
1040                         require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
1041                 } 
1042             }
1043         }
1044         
1045         
1046         
1047         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1048         uint256 contractTokenBalance = balanceOf(address(this));
1049         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1050 
1051         // swap and liquify
1052         if (
1053             !inSwapAndLiquify &&
1054             swapAndLiquifyEnabled &&
1055             balanceOf(uniswapV2Pair) > 0 &&
1056             totalTokensToSwap > 0 &&
1057             !_isExcludedFromFee[to] &&
1058             !_isExcludedFromFee[from] &&
1059             automatedMarketMakerPairs[to] &&
1060             overMinimumTokenBalance
1061         ) {
1062             swapBack();
1063         }
1064 
1065         bool takeFee = true;
1066 
1067         // If any account belongs to _isExcludedFromFee account then remove the fee
1068         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1069             takeFee = false;
1070             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1071         } else {
1072             // Buy
1073             if (automatedMarketMakerPairs[from]) {
1074                 removeAllFee();
1075                 _taxFee = _buyTaxFee;
1076                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1077                 buyOrSellSwitch = BUY;
1078             } 
1079             // Sell
1080             else if (automatedMarketMakerPairs[to]) {
1081                 removeAllFee();
1082                 _taxFee = _sellTaxFee;
1083                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1084                 buyOrSellSwitch = SELL;
1085                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1086                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1087                     _taxFee = _taxFee * 5;
1088                     _liquidityFee = _liquidityFee * 5;
1089                 }
1090             // Normal transfers do not get taxed
1091             } else {
1092                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1093                 removeAllFee();
1094                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1095             }
1096         }
1097         
1098         _tokenTransfer(from, to, amount, takeFee);
1099         
1100     }
1101 
1102     function swapBack() private lockTheSwap {
1103         uint256 contractBalance = balanceOf(address(this));
1104         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1105         
1106         // Halve the amount of liquidity tokens
1107         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1108         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1109         
1110         uint256 initialETHBalance = address(this).balance;
1111 
1112         swapTokensForETH(amountToSwapForETH); 
1113         
1114         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1115         
1116         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1117         
1118         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1119         
1120         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1121         ethForMarketing -= ethForDev;
1122         
1123         _liquidityTokensToSwap = 0;
1124         _marketingTokensToSwap = 0;
1125         
1126         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1127         (success,) = address(devAddress).call{value: ethForDev}("");
1128         
1129         addLiquidity(tokensForLiquidity, ethForLiquidity);
1130         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1131         
1132         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1133         if(address(this).balance > 1e17){
1134             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1135         }
1136     }
1137     
1138     // force Swap back if slippage above 49% for launch.
1139     function forceSwapBack() external onlyOwner {
1140         uint256 contractBalance = balanceOf(address(this));
1141         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1142         swapBack();
1143         emit OwnerForcedSwapBack(block.timestamp);
1144     }
1145     
1146     function swapTokensForETH(uint256 tokenAmount) private {
1147         address[] memory path = new address[](2);
1148         path[0] = address(this);
1149         path[1] = uniswapV2Router.WETH();
1150         _approve(address(this), address(uniswapV2Router), tokenAmount);
1151         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1152             tokenAmount,
1153             0, // accept any amount of ETH
1154             path,
1155             address(this),
1156             block.timestamp
1157         );
1158     }
1159     
1160     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1161         _approve(address(this), address(uniswapV2Router), tokenAmount);
1162         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1163             address(this),
1164             tokenAmount,
1165             0, // slippage is unavoidable
1166             0, // slippage is unavoidable
1167             liquidityAddress,
1168             block.timestamp
1169         );
1170     }
1171 
1172     function _tokenTransfer(
1173         address sender,
1174         address recipient,
1175         uint256 amount,
1176         bool takeFee
1177     ) private {
1178         if (!takeFee) removeAllFee();
1179 
1180         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1181             _transferFromExcluded(sender, recipient, amount);
1182         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1183             _transferToExcluded(sender, recipient, amount);
1184         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1185             _transferBothExcluded(sender, recipient, amount);
1186         } else {
1187             _transferStandard(sender, recipient, amount);
1188         }
1189 
1190         if (!takeFee) restoreAllFee();
1191     }
1192 
1193     function _transferStandard(
1194         address sender,
1195         address recipient,
1196         uint256 tAmount
1197     ) private {
1198         (
1199             uint256 rAmount,
1200             uint256 rTransferAmount,
1201             uint256 rFee,
1202             uint256 tTransferAmount,
1203             uint256 tFee,
1204             uint256 tLiquidity
1205         ) = _getValues(tAmount);
1206         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1207         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1208         _takeLiquidity(tLiquidity);
1209         _reflectFee(rFee, tFee);
1210         emit Transfer(sender, recipient, tTransferAmount);
1211     }
1212 
1213     function _transferToExcluded(
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
1227         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1228         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1229         _takeLiquidity(tLiquidity);
1230         _reflectFee(rFee, tFee);
1231         emit Transfer(sender, recipient, tTransferAmount);
1232     }
1233 
1234     function _transferFromExcluded(
1235         address sender,
1236         address recipient,
1237         uint256 tAmount
1238     ) private {
1239         (
1240             uint256 rAmount,
1241             uint256 rTransferAmount,
1242             uint256 rFee,
1243             uint256 tTransferAmount,
1244             uint256 tFee,
1245             uint256 tLiquidity
1246         ) = _getValues(tAmount);
1247         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1248         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1249         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1250         _takeLiquidity(tLiquidity);
1251         _reflectFee(rFee, tFee);
1252         emit Transfer(sender, recipient, tTransferAmount);
1253     }
1254 
1255     function _transferBothExcluded(
1256         address sender,
1257         address recipient,
1258         uint256 tAmount
1259     ) private {
1260         (
1261             uint256 rAmount,
1262             uint256 rTransferAmount,
1263             uint256 rFee,
1264             uint256 tTransferAmount,
1265             uint256 tFee,
1266             uint256 tLiquidity
1267         ) = _getValues(tAmount);
1268         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1269         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1270         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1271         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1272         _takeLiquidity(tLiquidity);
1273         _reflectFee(rFee, tFee);
1274         emit Transfer(sender, recipient, tTransferAmount);
1275     }
1276 
1277     function _reflectFee(uint256 rFee, uint256 tFee) private {
1278         _rTotal = _rTotal.sub(rFee);
1279         _tFeeTotal = _tFeeTotal.add(tFee);
1280     }
1281 
1282     function _getValues(uint256 tAmount)
1283         private
1284         view
1285         returns (
1286             uint256,
1287             uint256,
1288             uint256,
1289             uint256,
1290             uint256,
1291             uint256
1292         )
1293     {
1294         (
1295             uint256 tTransferAmount,
1296             uint256 tFee,
1297             uint256 tLiquidity
1298         ) = _getTValues(tAmount);
1299         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1300             tAmount,
1301             tFee,
1302             tLiquidity,
1303             _getRate()
1304         );
1305         return (
1306             rAmount,
1307             rTransferAmount,
1308             rFee,
1309             tTransferAmount,
1310             tFee,
1311             tLiquidity
1312         );
1313     }
1314 
1315     function _getTValues(uint256 tAmount)
1316         private
1317         view
1318         returns (
1319             uint256,
1320             uint256,
1321             uint256
1322         )
1323     {
1324         uint256 tFee = calculateTaxFee(tAmount);
1325         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1326         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1327         return (tTransferAmount, tFee, tLiquidity);
1328     }
1329 
1330     function _getRValues(
1331         uint256 tAmount,
1332         uint256 tFee,
1333         uint256 tLiquidity,
1334         uint256 currentRate
1335     )
1336         private
1337         pure
1338         returns (
1339             uint256,
1340             uint256,
1341             uint256
1342         )
1343     {
1344         uint256 rAmount = tAmount.mul(currentRate);
1345         uint256 rFee = tFee.mul(currentRate);
1346         uint256 rLiquidity = tLiquidity.mul(currentRate);
1347         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1348         return (rAmount, rTransferAmount, rFee);
1349     }
1350 
1351     function _getRate() private view returns (uint256) {
1352         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1353         return rSupply.div(tSupply);
1354     }
1355 
1356     function _getCurrentSupply() private view returns (uint256, uint256) {
1357         uint256 rSupply = _rTotal;
1358         uint256 tSupply = _tTotal;
1359         for (uint256 i = 0; i < _excluded.length; i++) {
1360             if (
1361                 _rOwned[_excluded[i]] > rSupply ||
1362                 _tOwned[_excluded[i]] > tSupply
1363             ) return (_rTotal, _tTotal);
1364             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1365             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1366         }
1367         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1368         return (rSupply, tSupply);
1369     }
1370 
1371     function _takeLiquidity(uint256 tLiquidity) private {
1372         if(buyOrSellSwitch == BUY){
1373             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1374             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1375         } else if(buyOrSellSwitch == SELL){
1376             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1377             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1378         }
1379         uint256 currentRate = _getRate();
1380         uint256 rLiquidity = tLiquidity.mul(currentRate);
1381         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1382         if (_isExcluded[address(this)])
1383             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1384     }
1385 
1386     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1387         return _amount.mul(_taxFee).div(10**2);
1388     }
1389 
1390     function calculateLiquidityFee(uint256 _amount)
1391         private
1392         view
1393         returns (uint256)
1394     {
1395         return _amount.mul(_liquidityFee).div(10**2);
1396     }
1397 
1398     function removeAllFee() private {
1399         if (_taxFee == 0 && _liquidityFee == 0) return;
1400 
1401         _previousTaxFee = _taxFee;
1402         _previousLiquidityFee = _liquidityFee;
1403 
1404         _taxFee = 0;
1405         _liquidityFee = 0;
1406     }
1407 
1408     function restoreAllFee() private {
1409         _taxFee = _previousTaxFee;
1410         _liquidityFee = _previousLiquidityFee;
1411     }
1412 
1413     function isExcludedFromFee(address account) external view returns (bool) {
1414         return _isExcludedFromFee[account];
1415     }
1416     
1417      function removeBoughtEarly(address account) external onlyOwner {
1418         boughtEarly[account] = false;
1419         emit RemovedSniper(account);
1420     }
1421 
1422     function excludeFromFee(address account) external onlyOwner {
1423         _isExcludedFromFee[account] = true;
1424         emit ExcludeFromFee(account);
1425     }
1426 
1427     function includeInFee(address account) external onlyOwner {
1428         _isExcludedFromFee[account] = false;
1429         emit IncludeInFee(account);
1430     }
1431 
1432     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1433         external
1434         onlyOwner
1435     {
1436         _buyTaxFee = buyTaxFee;
1437         _buyLiquidityFee = buyLiquidityFee;
1438         _buyMarketingFee = buyMarketingFee;
1439         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1440         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1441     }
1442 
1443     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1444         external
1445         onlyOwner
1446     {
1447         _sellTaxFee = sellTaxFee;
1448         _sellLiquidityFee = sellLiquidityFee;
1449         _sellMarketingFee = sellMarketingFee;
1450         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1451         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1452     }
1453 
1454 
1455     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1456         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1457         _isExcludedFromFee[marketingAddress] = false;
1458         marketingAddress = payable(_marketingAddress);
1459         _isExcludedFromFee[marketingAddress] = true;
1460         emit UpdatedMarketingAddress(_marketingAddress);
1461     }
1462     
1463     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1464         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1465         liquidityAddress = payable(_liquidityAddress);
1466         _isExcludedFromFee[liquidityAddress] = true;
1467         emit UpdatedLiquidityAddress(_liquidityAddress);
1468     }
1469 
1470     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1471         swapAndLiquifyEnabled = _enabled;
1472         emit SwapAndLiquifyEnabledUpdated(_enabled);
1473     }
1474 
1475     // To receive ETH from uniswapV2Router when swapping
1476     receive() external payable {}
1477 
1478     function transferForeignToken(address _token, address _to)
1479         external
1480         onlyOwner
1481         returns (bool _sent)
1482     {
1483         require(_token != address(0), "_token address cannot be 0");
1484         require(_token != address(this), "Can't withdraw native tokens");
1485         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1486         _sent = IERC20(_token).transfer(_to, _contractBalance);
1487         emit TransferForeignToken(_token, _contractBalance);
1488     }
1489     
1490     // withdraw ETH if stuck before launch
1491     function withdrawStuckETH() external onlyOwner {
1492         require(!tradingActive, "Can only withdraw if trading hasn't started");
1493         bool success;
1494         (success,) = address(msg.sender).call{value: address(this).balance}("");
1495     }
1496 }