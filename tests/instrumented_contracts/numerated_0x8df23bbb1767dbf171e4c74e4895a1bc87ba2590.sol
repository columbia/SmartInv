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
598 contract KOOCHIE_INU is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress;
603         
604     address payable public devAddress;
605         
606     address payable public liquidityAddress;
607     
608     address private _owner = 0x981bD7172ff59A38A51B1cdfd2C75f22070bd11E;
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
625     uint256 private constant _tTotal = 1e24;
626     uint256 private _rTotal = (MAX - (MAX % _tTotal));
627     uint256 private _tFeeTotal;
628 
629     string private constant _name = "KOOCHIE INU";
630     string private constant _symbol = "KOO";
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
646     uint256 public launchTime = 0;
647     uint256 public maxAmountCanBuy = 1e20;
648 
649     uint256 public _buyTaxFee = 2;
650     uint256 public _buyLiquidityFee = 2;
651     uint256 public _buyMarketingFee = 4;
652     
653     uint256 public _sellTaxFee = 2;
654     uint256 public _sellLiquidityFee = 2;
655     uint256 public _sellMarketingFee = 4;
656     
657     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
658     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
659     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
660     
661     uint256 public _liquidityTokensToSwap;
662     uint256 public _marketingTokensToSwap;
663     
664     uint256 public maxTransactionAmount;
665     uint256 public maxWalletAmount;
666     mapping (address => bool) public _isExcludedMaxTransactionAmount;
667     
668     bool private gasLimitActive = true;
669     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
670     
671     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
672     // could be subject to a maximum transfer amount
673     mapping (address => bool) public automatedMarketMakerPairs;
674     mapping (address => bool) public blackListAdd;
675 
676     uint256 private minimumTokensBeforeSwap;
677 
678     IUniswapV2Router02 public uniswapV2Router;
679     address public uniswapV2Pair;
680 
681     bool inSwapAndLiquify;
682     bool public swapAndLiquifyEnabled = false;
683     bool public tradingActive = false;
684     bool public stopBlkListing = false;
685 
686     event SwapAndLiquifyEnabledUpdated(bool enabled);
687     event SwapAndLiquify(
688         uint256 tokensSwapped,
689         uint256 ethReceived,
690         uint256 tokensIntoLiquidity
691     );
692 
693     event SwapETHForTokens(uint256 amountIn, address[] path);
694 
695     event SwapTokensForETH(uint256 amountIn, address[] path);
696     
697     event SetAutomatedMarketMakerPair(address pair, bool value);
698     
699     event ExcludeFromReward(address excludedAddress);
700     
701     event IncludeInReward(address includedAddress);
702     
703     event ExcludeFromFee(address excludedAddress);
704     
705     event IncludeInFee(address includedAddress);
706     
707     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
708     
709     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
710     
711     event TransferForeignToken(address token, uint256 amount);
712     
713     event UpdatedMarketingAddress(address marketing);
714     
715     event UpdatedLiquidityAddress(address liquidity);
716     
717     event OwnerForcedSwapBack(uint256 timestamp);
718     
719     event BoughtEarly(address indexed sniper);
720     
721     event RemovedSniper(address indexed notsnipersupposedly);
722 
723     modifier lockTheSwap() {
724         inSwapAndLiquify = true;
725         _;
726         inSwapAndLiquify = false;
727     }
728 
729     constructor() payable {
730         _rOwned[_owner] = _rTotal / 1000 * 700;
731         _rOwned[address(this)] = _rTotal / 1000 * 300;
732         
733         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
734         maxWalletAmount = _tTotal * 15 / 1000; // 1.5% maxWalletAmount
735         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
736         
737         marketingAddress = payable(0xb72cFA384304ef3734EBd374b54Dbb901Ce236D8); // Marketing Address
738         
739         devAddress = payable(0xfd70D3e84219826276948d92AC93c3dD27E50487); // Dev Address
740         
741         liquidityAddress = payable(_owner);
742         
743         _isExcludedFromFee[_owner] = true;
744         _isExcludedFromFee[owner()] = true;
745         _isExcludedFromFee[address(this)] = true;
746         _isExcludedFromFee[marketingAddress] = true;
747         _isExcludedFromFee[liquidityAddress] = true;
748         
749         excludeFromMaxTransaction(owner(), true);
750         excludeFromMaxTransaction(address(this), true);
751         excludeFromMaxTransaction(address(0xdead), true);
752         
753         emit Transfer(address(0), _owner, _tTotal * 700 / 1000);
754         emit Transfer(address(0), address(this), _tTotal * 300 / 1000);
755     }
756 
757     function name() external pure returns (string memory) {
758         return _name;
759     }
760 
761     function symbol() external pure returns (string memory) {
762         return _symbol;
763     }
764 
765     function decimals() external pure returns (uint8) {
766         return _decimals;
767     }
768 
769     function totalSupply() external pure override returns (uint256) {
770         return _tTotal;
771     }
772 
773     function balanceOf(address account) public view override returns (uint256) {
774         if (_isExcluded[account]) return _tOwned[account];
775         return tokenFromReflection(_rOwned[account]);
776     }
777 
778     function transfer(address recipient, uint256 amount)
779         external
780         override
781         returns (bool)
782     {
783         _transfer(_msgSender(), recipient, amount);
784         return true;
785     }
786 
787     function allowance(address owner, address spender)
788         external
789         view
790         override
791         returns (uint256)
792     {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount)
797         public
798         override
799         returns (bool)
800     {
801         _approve(_msgSender(), spender, amount);
802         return true;
803     }
804 
805     function transferFrom(
806         address sender,
807         address recipient,
808         uint256 amount
809     ) external override returns (bool) {
810         _transfer(sender, recipient, amount);
811         _approve(
812             sender,
813             _msgSender(),
814             _allowances[sender][_msgSender()].sub(
815                 amount,
816                 "ERC20: transfer amount exceeds allowance"
817             )
818         );
819         return true;
820     }
821 
822     function increaseAllowance(address spender, uint256 addedValue)
823         external
824         virtual
825         returns (bool)
826     {
827         _approve(
828             _msgSender(),
829             spender,
830             _allowances[_msgSender()][spender].add(addedValue)
831         );
832         return true;
833     }
834 
835     function decreaseAllowance(address spender, uint256 subtractedValue)
836         external
837         virtual
838         returns (bool)
839     {
840         _approve(
841             _msgSender(),
842             spender,
843             _allowances[_msgSender()][spender].sub(
844                 subtractedValue,
845                 "ERC20: decreased allowance below zero"
846             )
847         );
848         return true;
849     }
850 
851     function isExcludedFromReward(address account)
852         external
853         view
854         returns (bool)
855     {
856         return _isExcluded[account];
857     }
858 
859     function totalFees() external view returns (uint256) {
860         return _tFeeTotal;
861     }
862     
863     // remove limits after token is stable - 30-60 minutes
864     function removeLimits() external onlyOwner returns (bool){
865         limitsInEffect = false;
866         gasLimitActive = false;
867         transferDelayEnabled = false;
868         return true;
869     }
870     
871     // disable Transfer delay
872     function disableTransferDelay() external onlyOwner returns (bool){
873         transferDelayEnabled = false;
874         return true;
875     }
876     
877     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
878         _isExcludedMaxTransactionAmount[updAds] = isEx;
879     }
880     
881     // once enabled, can never be turned off
882     function enableTrading() internal onlyOwner {
883         tradingActive = true;
884         swapAndLiquifyEnabled = true;
885         tradingActiveBlock = block.number;
886         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
887     }
888     
889     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
890     function launch() external onlyOwner returns (bool){
891         require(!tradingActive, "Trading is already active, cannot relaunch.");
892         
893         enableTrading();
894         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
895         excludeFromMaxTransaction(address(_uniswapV2Router), true);
896         uniswapV2Router = _uniswapV2Router;
897         _approve(address(this), address(uniswapV2Router), _tTotal);
898         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
899         excludeFromMaxTransaction(address(uniswapV2Pair), true);
900         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
901         require(address(this).balance > 0, "Must have ETH on contract to launch");
902         addLiquidity(balanceOf(address(this)), address(this).balance);
903         transferOwnership(_owner);
904         launchTime = block.timestamp;
905         return true;
906     }
907     
908     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
909         return minimumTokensBeforeSwap;
910     }
911     
912     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
913         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
914 
915         _setAutomatedMarketMakerPair(pair, value);
916     }
917 
918     function _setAutomatedMarketMakerPair(address pair, bool value) private {
919         automatedMarketMakerPairs[pair] = value;
920         _isExcludedMaxTransactionAmount[pair] = value;
921         if(value){excludeFromReward(pair);}
922         if(!value){includeInReward(pair);}
923     }
924     
925     function setGasPriceLimit(uint256 gas) external onlyOwner {
926         require(gas >= 200);
927         gasPriceLimit = gas * 1 gwei;
928     }
929 
930     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
931         external
932         view
933         returns (uint256)
934     {
935         require(tAmount <= _tTotal, "Amount must be less than supply");
936         if (!deductTransferFee) {
937             (uint256 rAmount, , , , , ) = _getValues(tAmount);
938             return rAmount;
939         } else {
940             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
941             return rTransferAmount;
942         }
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
968     function includeInReward(address account) public onlyOwner {
969         require(_isExcluded[account], "Account is not excluded");
970         for (uint256 i = 0; i < _excluded.length; i++) {
971             if (_excluded[i] == account) {
972                 _excluded[i] = _excluded[_excluded.length - 1];
973                 _tOwned[account] = 0;
974                 _isExcluded[account] = false;
975                 _excluded.pop();
976                 break;
977             }
978         }
979     }
980  
981     function _approve(
982         address owner,
983         address spender,
984         uint256 amount
985     ) private {
986         require(owner != address(0), "ERC20: approve from the zero address");
987         require(spender != address(0), "ERC20: approve to the zero address");
988 
989         _allowances[owner][spender] = amount;
990         emit Approval(owner, spender, amount);
991     }
992 
993     function _transfer(
994         address from,
995         address to,
996         uint256 amount
997     ) private {
998         require(from != address(0), "ERC20: transfer from the zero address");
999         require(to != address(0), "ERC20: transfer to the zero address");
1000         require(amount > 0, "Transfer amount must be greater than zero");
1001         require(!blackListAdd[from], "You are blacklisted, contact owner to solve this problem.");
1002         require(!blackListAdd[to], "You can't send to a blacklisted address.");
1003         
1004         //@dev Limit the transfer tokens for first 1 minutes
1005         require(block.timestamp > launchTime + 1 minutes  || amount <= maxAmountCanBuy, "You can't buy large amount.");
1006         
1007         if(!tradingActive) {
1008             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1009         }
1010         
1011         if(limitsInEffect){
1012             if (
1013                 from != owner() &&
1014                 to != owner() &&
1015                 to != address(0) &&
1016                 to != address(0xdead) &&
1017                 !inSwapAndLiquify
1018             ){
1019                 
1020                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1021                     boughtEarly[to] = true;
1022                     emit BoughtEarly(to);
1023                 }
1024                 
1025                 // only use to prevent sniper buys in the first blocks.
1026                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1027                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1028                 }
1029                 
1030                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1031                 if (transferDelayEnabled){
1032                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1033                         require(_holderLastTransferTimestamp[to] < block.number && _holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1034                         _holderLastTransferTimestamp[to] = block.number;
1035                         _holderLastTransferTimestamp[tx.origin] = block.number;
1036                     }
1037                 }
1038                 
1039                 //when buy
1040                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1041                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1042                 } 
1043                 //when sell
1044                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1045                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1046                 }
1047                 
1048                 if (!_isExcludedMaxTransactionAmount[to]) {
1049                         require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
1050                 } 
1051             }
1052         }
1053         
1054         
1055         
1056         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1057         uint256 contractTokenBalance = balanceOf(address(this));
1058         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1059 
1060         // swap and liquify
1061         if (
1062             !inSwapAndLiquify &&
1063             swapAndLiquifyEnabled &&
1064             balanceOf(uniswapV2Pair) > 0 &&
1065             totalTokensToSwap > 0 &&
1066             !_isExcludedFromFee[to] &&
1067             !_isExcludedFromFee[from] &&
1068             automatedMarketMakerPairs[to] &&
1069             overMinimumTokenBalance
1070         ) {
1071             swapBack();
1072         }
1073 
1074         bool takeFee = true;
1075 
1076         // If any account belongs to _isExcludedFromFee account then remove the fee
1077         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1078             takeFee = false;
1079             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1080         } else {
1081             // Buy
1082             if (automatedMarketMakerPairs[from]) {
1083                 removeAllFee();
1084                 _taxFee = _buyTaxFee;
1085                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1086                 buyOrSellSwitch = BUY;
1087             } 
1088             // Sell
1089             else if (automatedMarketMakerPairs[to]) {
1090                 removeAllFee();
1091                 _taxFee = _sellTaxFee;
1092                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1093                 buyOrSellSwitch = SELL;
1094                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1095                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1096                     _taxFee = _taxFee * 5;
1097                     _liquidityFee = _liquidityFee * 5;
1098                 }
1099             // Normal transfers do not get taxed
1100             } else {
1101                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1102                 removeAllFee();
1103                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1104             }
1105         }
1106         
1107         _tokenTransfer(from, to, amount, takeFee);
1108         
1109     }
1110 
1111     function swapBack() private lockTheSwap {
1112         uint256 contractBalance = balanceOf(address(this));
1113         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1114         
1115         // Halve the amount of liquidity tokens
1116         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1117         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1118         
1119         uint256 initialETHBalance = address(this).balance;
1120 
1121         swapTokensForETH(amountToSwapForETH); 
1122         
1123         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1124         
1125         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1126         
1127         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1128         
1129         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1130         ethForMarketing -= ethForDev;
1131         
1132         _liquidityTokensToSwap = 0;
1133         _marketingTokensToSwap = 0;
1134         
1135         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1136         (success,) = address(devAddress).call{value: ethForDev}("");
1137         
1138         addLiquidity(tokensForLiquidity, ethForLiquidity);
1139         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1140         
1141         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1142         if(address(this).balance > 1e17){
1143             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1144         }
1145     }
1146     
1147     // force Swap back if slippage above 49% for launch.
1148     function forceSwapBack() external onlyOwner {
1149         uint256 contractBalance = balanceOf(address(this));
1150         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1151         swapBack();
1152         emit OwnerForcedSwapBack(block.timestamp);
1153     }
1154     
1155     function swapTokensForETH(uint256 tokenAmount) private {
1156         address[] memory path = new address[](2);
1157         path[0] = address(this);
1158         path[1] = uniswapV2Router.WETH();
1159         _approve(address(this), address(uniswapV2Router), tokenAmount);
1160         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1161             tokenAmount,
1162             0, // accept any amount of ETH
1163             path,
1164             address(this),
1165             block.timestamp
1166         );
1167     }
1168     
1169     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1170         _approve(address(this), address(uniswapV2Router), tokenAmount);
1171         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1172             address(this),
1173             tokenAmount,
1174             0, // slippage is unavoidable
1175             0, // slippage is unavoidable
1176             liquidityAddress,
1177             block.timestamp
1178         );
1179     }
1180 
1181     function _tokenTransfer(
1182         address sender,
1183         address recipient,
1184         uint256 amount,
1185         bool takeFee
1186     ) private {
1187         if (!takeFee) removeAllFee();
1188 
1189         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1190             _transferFromExcluded(sender, recipient, amount);
1191         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1192             _transferToExcluded(sender, recipient, amount);
1193         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1194             _transferBothExcluded(sender, recipient, amount);
1195         } else {
1196             _transferStandard(sender, recipient, amount);
1197         }
1198 
1199         if (!takeFee) restoreAllFee();
1200     }
1201 
1202     function _transferStandard(
1203         address sender,
1204         address recipient,
1205         uint256 tAmount
1206     ) private {
1207         (
1208             uint256 rAmount,
1209             uint256 rTransferAmount,
1210             uint256 rFee,
1211             uint256 tTransferAmount,
1212             uint256 tFee,
1213             uint256 tLiquidity
1214         ) = _getValues(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1217         _takeLiquidity(tLiquidity);
1218         _reflectFee(rFee, tFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 
1222     function _transferToExcluded(
1223         address sender,
1224         address recipient,
1225         uint256 tAmount
1226     ) private {
1227         (
1228             uint256 rAmount,
1229             uint256 rTransferAmount,
1230             uint256 rFee,
1231             uint256 tTransferAmount,
1232             uint256 tFee,
1233             uint256 tLiquidity
1234         ) = _getValues(tAmount);
1235         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1236         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1237         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1238         _takeLiquidity(tLiquidity);
1239         _reflectFee(rFee, tFee);
1240         emit Transfer(sender, recipient, tTransferAmount);
1241     }
1242 
1243     function _transferFromExcluded(
1244         address sender,
1245         address recipient,
1246         uint256 tAmount
1247     ) private {
1248         (
1249             uint256 rAmount,
1250             uint256 rTransferAmount,
1251             uint256 rFee,
1252             uint256 tTransferAmount,
1253             uint256 tFee,
1254             uint256 tLiquidity
1255         ) = _getValues(tAmount);
1256         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1257         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1258         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1259         _takeLiquidity(tLiquidity);
1260         _reflectFee(rFee, tFee);
1261         emit Transfer(sender, recipient, tTransferAmount);
1262     }
1263 
1264     function _transferBothExcluded(
1265         address sender,
1266         address recipient,
1267         uint256 tAmount
1268     ) private {
1269         (
1270             uint256 rAmount,
1271             uint256 rTransferAmount,
1272             uint256 rFee,
1273             uint256 tTransferAmount,
1274             uint256 tFee,
1275             uint256 tLiquidity
1276         ) = _getValues(tAmount);
1277         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1278         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1279         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1280         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1281         _takeLiquidity(tLiquidity);
1282         _reflectFee(rFee, tFee);
1283         emit Transfer(sender, recipient, tTransferAmount);
1284     }
1285 
1286     function _reflectFee(uint256 rFee, uint256 tFee) private {
1287         _rTotal = _rTotal.sub(rFee);
1288         _tFeeTotal = _tFeeTotal.add(tFee);
1289     }
1290 
1291     function _getValues(uint256 tAmount)
1292         private
1293         view
1294         returns (
1295             uint256,
1296             uint256,
1297             uint256,
1298             uint256,
1299             uint256,
1300             uint256
1301         )
1302     {
1303         (
1304             uint256 tTransferAmount,
1305             uint256 tFee,
1306             uint256 tLiquidity
1307         ) = _getTValues(tAmount);
1308         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1309             tAmount,
1310             tFee,
1311             tLiquidity,
1312             _getRate()
1313         );
1314         return (
1315             rAmount,
1316             rTransferAmount,
1317             rFee,
1318             tTransferAmount,
1319             tFee,
1320             tLiquidity
1321         );
1322     }
1323 
1324     function _getTValues(uint256 tAmount)
1325         private
1326         view
1327         returns (
1328             uint256,
1329             uint256,
1330             uint256
1331         )
1332     {
1333         uint256 tFee = calculateTaxFee(tAmount);
1334         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1335         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1336         return (tTransferAmount, tFee, tLiquidity);
1337     }
1338 
1339     function _getRValues(
1340         uint256 tAmount,
1341         uint256 tFee,
1342         uint256 tLiquidity,
1343         uint256 currentRate
1344     )
1345         private
1346         pure
1347         returns (
1348             uint256,
1349             uint256,
1350             uint256
1351         )
1352     {
1353         uint256 rAmount = tAmount.mul(currentRate);
1354         uint256 rFee = tFee.mul(currentRate);
1355         uint256 rLiquidity = tLiquidity.mul(currentRate);
1356         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1357         return (rAmount, rTransferAmount, rFee);
1358     }
1359 
1360     function _getRate() private view returns (uint256) {
1361         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1362         return rSupply.div(tSupply);
1363     }
1364 
1365     function _getCurrentSupply() private view returns (uint256, uint256) {
1366         uint256 rSupply = _rTotal;
1367         uint256 tSupply = _tTotal;
1368         for (uint256 i = 0; i < _excluded.length; i++) {
1369             if (
1370                 _rOwned[_excluded[i]] > rSupply ||
1371                 _tOwned[_excluded[i]] > tSupply
1372             ) return (_rTotal, _tTotal);
1373             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1374             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1375         }
1376         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1377         return (rSupply, tSupply);
1378     }
1379 
1380     function _takeLiquidity(uint256 tLiquidity) private {
1381         if(buyOrSellSwitch == BUY){
1382             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1383             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1384         } else if(buyOrSellSwitch == SELL){
1385             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1386             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1387         }
1388         uint256 currentRate = _getRate();
1389         uint256 rLiquidity = tLiquidity.mul(currentRate);
1390         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1391         if (_isExcluded[address(this)])
1392             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1393     }
1394 
1395     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1396         return _amount.mul(_taxFee).div(10**2);
1397     }
1398 
1399     function calculateLiquidityFee(uint256 _amount)
1400         private
1401         view
1402         returns (uint256)
1403     {
1404         return _amount.mul(_liquidityFee).div(10**2);
1405     }
1406 
1407     function removeAllFee() private {
1408         if (_taxFee == 0 && _liquidityFee == 0) return;
1409 
1410         _previousTaxFee = _taxFee;
1411         _previousLiquidityFee = _liquidityFee;
1412 
1413         _taxFee = 0;
1414         _liquidityFee = 0;
1415     }
1416 
1417     function restoreAllFee() private {
1418         _taxFee = _previousTaxFee;
1419         _liquidityFee = _previousLiquidityFee;
1420     }
1421 
1422     function isExcludedFromFee(address account) external view returns (bool) {
1423         return _isExcludedFromFee[account];
1424     }
1425     
1426      function removeBoughtEarly(address account) external onlyOwner {
1427         boughtEarly[account] = false;
1428         emit RemovedSniper(account);
1429     }
1430 
1431     function excludeFromFee(address account) external onlyOwner {
1432         _isExcludedFromFee[account] = true;
1433         emit ExcludeFromFee(account);
1434     }
1435 
1436     function includeInFee(address account) external onlyOwner {
1437         _isExcludedFromFee[account] = false;
1438         emit IncludeInFee(account);
1439     }
1440 
1441     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1442         external
1443         onlyOwner
1444     {
1445         _buyTaxFee = buyTaxFee;
1446         _buyLiquidityFee = buyLiquidityFee;
1447         _buyMarketingFee = buyMarketingFee;
1448         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1449         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1450     }
1451 
1452     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1453         external
1454         onlyOwner
1455     {
1456         _sellTaxFee = sellTaxFee;
1457         _sellLiquidityFee = sellLiquidityFee;
1458         _sellMarketingFee = sellMarketingFee;
1459         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1460         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1461     }
1462 
1463 
1464     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1465         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1466         _isExcludedFromFee[marketingAddress] = false;
1467         marketingAddress = payable(_marketingAddress);
1468         _isExcludedFromFee[marketingAddress] = true;
1469         emit UpdatedMarketingAddress(_marketingAddress);
1470     }
1471     
1472     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1473         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1474         liquidityAddress = payable(_liquidityAddress);
1475         _isExcludedFromFee[liquidityAddress] = true;
1476         emit UpdatedLiquidityAddress(_liquidityAddress);
1477     }
1478 
1479     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1480         swapAndLiquifyEnabled = _enabled;
1481         emit SwapAndLiquifyEnabledUpdated(_enabled);
1482     }
1483 
1484     function addOnBlackList(address account) public onlyOwner {
1485         require(!stopBlkListing, "You have disabled this function");
1486         blackListAdd[account] = true;
1487     }
1488     
1489     function stopAddingOnBlacklist() public onlyOwner {
1490         stopBlkListing = true;
1491     }
1492 
1493     function removeFromBlackList(address account) public onlyOwner {
1494         blackListAdd[account] = false;
1495     }
1496     
1497     function setBuyLimit(uint256 amount) public onlyOwner {
1498         maxAmountCanBuy = amount;
1499     }
1500 
1501     // To receive ETH from uniswapV2Router when swapping
1502     receive() external payable {}
1503 
1504     function transferForeignToken(address _token, address _to)
1505         external
1506         onlyOwner
1507         returns (bool _sent)
1508     {
1509         require(_token != address(0), "_token address cannot be 0");
1510         require(_token != address(this), "Can't withdraw native tokens");
1511         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1512         _sent = IERC20(_token).transfer(_to, _contractBalance);
1513         emit TransferForeignToken(_token, _contractBalance);
1514     }
1515     
1516     // withdraw ETH if stuck before launch
1517     function withdrawStuckETH() external onlyOwner {
1518         require(!tradingActive, "Can only withdraw if trading hasn't started");
1519         bool success;
1520         (success,) = address(msg.sender).call{value: address(this).balance}("");
1521     }
1522 }